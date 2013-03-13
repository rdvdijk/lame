require 'spec_helper'

module LAME
  module Decoding
    describe Mp3DataHeaderParser do

      let(:decode_flags) { stub("decode flags") }
      let(:stream) { StringIO.new(stream_string) }
      let(:parser) { Mp3DataHeaderParser.new(decode_flags, stream) }

      let(:stream_string) do
        "a"*100
      end

      it "reads 100 bytes from the stream" do
        stream.should_receive(:read).with(100)
        parser.parse!
      end

      it "tries to parse headers with LAME" do
        LAME.should_receive(:hip_decode1_headersB) do |decode_flags, in_buffer, size, out_left, out_right, mp3_data, enc_delay, enc_padding|
          decode_flags.should            eql decode_flags
          in_buffer.get_string(0).should eql "a"*100
          size.should                    eql 100
          mp3_data.should                be_a(LAME::FFI::MP3Data)
        end
        parser.parse!
      end

      it "reads 100 bytes until a header was parsed" do
      end

      it "returns the parsed mp3 data if a header was parsed"

      it "raises an error if the header could not be parsed"

    end
  end
end
