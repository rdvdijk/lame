require 'spec_helper'

module LAME
  module Decoding
    describe Mp3DataHeaderParser do

      subject(:parser) { Mp3DataHeaderParser.new(decode_flags, stream) }

      let(:decode_flags) { stub("decode flags") }
      let(:stream) { StringIO.new(stream_string) }
      let(:mpeg_finder) { stub }

      let(:stream_string) { "a"*100 }

      before do
        LAME.stub(:hip_decode1_headersB) do |_, _, _, _, _, mp3_data, _, _|
          # fake that the header was found
          mp3_data[:header_parsed] = 1
        end
      end

      it "seeks the input stream until the first mpeg frame" do
        MPEGAudioAudioFrameFinder.should_receive(:new).with(stream).and_return(mpeg_finder)
        mpeg_finder.should_receive(:find!)

        parser.parse!
      end

      context "decoding headers" do

        it "reads 100 bytes from the stream" do
          stream.should_receive(:read).with(100).and_return("a"*100)
          parser.parse!
        end

        it "parses headers with LAME" do
          LAME.should_receive(:hip_decode1_headersB) do |decode_flags, in_buffer, size, _, _, mp3_data, _, _|
            decode_flags.should            eql decode_flags
            in_buffer.get_string(0).should eql "a"*100
            size.should                    eql 100
            mp3_data.should                be_a(LAME::FFI::MP3Data)

            # fake that the header was found
            mp3_data[:header_parsed] = 1
          end
          parser.parse!
        end

        context "larger input" do
          let(:stream_string) { "a"*1000 }
          let(:expected_reads) { 5 }

          it "reads 100 bytes until a header was parsed" do
            decode_count = 0

            LAME.should_receive(:hip_decode1_headersB).exactly(expected_reads).times

            LAME.stub(:hip_decode1_headersB) do |_, _, _, _, _, mp3_data, _, _|
              decode_count += 1

              # simulate parsed header after 5 reads:
              mp3_data[:header_parsed] = (decode_count == expected_reads) ? 1 : 0
            end

            parser.parse!
          end
        end

        it "returns the parsed mp3 data if a header was parsed" do
          mp3_data = stub("mp3 data", :header_parsed? => true)
          LAME::FFI::MP3Data.stub(:new).and_return(mp3_data)
          LAME.stub(:hip_decode1_headersB)

          parser.parse!.should eql mp3_data
        end

        it "raises an error if the header could not be parsed" do
          mp3_data = stub("mp3 data", :header_parsed? => false)
          LAME::FFI::MP3Data.stub(:new).and_return(mp3_data)
          LAME.stub(:hip_decode1_headersB)

          expect {
            parser.parse!
          }.to raise_error(Mp3DataHeaderNotFoundError)
        end

      end

    end
  end
end
