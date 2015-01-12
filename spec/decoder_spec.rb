require 'spec_helper'

module LAME
  describe Decoder do

    let(:decode_flags)           { double("decode flags") }
    let(:mp3_file)               { double("mp3 file") }
    let(:id3_tag_parser)         { double("id3 tag parser", :skip! => nil) }
    let(:mp3_data_header_parser) { double("mp3 data header parser", :parse! => nil) }

    # Stub away all collaborators:
    before do
      allow(Decoding::Id3TagParser).to receive(:new).and_return(id3_tag_parser)
      allow(Decoding::Mp3DataHeaderParser).to receive(:new).and_return(mp3_data_header_parser)
      allow(FFI::DecodeFlags).to receive(:new).and_return(decode_flags)
    end

    subject(:decoder) { Decoder.new(mp3_file) }

    context "initialization" do

      it "initializes DecodeFlags" do
        expect(FFI::DecodeFlags).to receive(:new)
        Decoder.new(mp3_file)
      end

      it "has the DecodeFlags" do
        decode_flags = double("decode_flags")
        allow(FFI::DecodeFlags).to receive(:new).and_return(decode_flags)
        expect(decoder.decode_flags).to eql decode_flags
      end

      it "has the mp3 file path" do
        expect(decoder.mp3_file).to eql mp3_file
      end

      it "skips the id3 offset" do
        expect(Decoding::Id3TagParser).to receive(:new).with(mp3_file)
        expect(id3_tag_parser).to receive(:skip!)

        decoder
      end

      it "parses the mp3 data header" do
        parser = double("parser")
        mp3_data = double("mp3_data")
        expect(Decoding::Mp3DataHeaderParser).to receive(:new).with(decode_flags, mp3_file).and_return(parser)
        expect(parser).to receive(:parse!).and_return(mp3_data)

        expect(decoder.mp3_data).to eql mp3_data
      end

    end

    context "after initialization" do

      let(:mp3_data) { double("mp3 data") }

      # stubbing galore!
      before do
        allow(FFI::DecodeFlags).to receive(:new).and_return(decode_flags)

        parser = double("parser")
        allow(Decoding::Mp3DataHeaderParser).to receive(:new).and_return(parser)
        allow(parser).to receive(:parse!).and_return(mp3_data)
      end

      describe "#each_decoded_frame" do

        let(:stream_decoder) { double("stream_decoder") }
        before do
          allow(Decoding::StreamDecoder).to receive(:new).and_return(stream_decoder)
        end

        it "initializes a stream decoder with mp3 file and mp3 data" do
          allow(stream_decoder).to receive(:each_decoded_frame)

          expect(Decoding::StreamDecoder).to receive(:new).with(decode_flags, mp3_data, mp3_file)

          decoder.each_decoded_frame
        end

        it "delegates to a stream decoder" do
          expect(stream_decoder).to receive(:each_decoded_frame)

          decoder.each_decoded_frame
        end

        it "re-yields the stream decoder's yield" do
          allow(stream_decoder).to receive(:each_decoded_frame).and_yield(:one).and_yield(:two)

          expect { |block|
            decoder.each_decoded_frame(&block)
          }.to yield_successive_args(:one, :two)
        end

      end

      describe "#channel_mode" do

        it "delegates to mp3_data" do
          expect(mp3_data).to receive(:channel_mode).and_return(:stereo)
          expect(decoder.channel_mode).to eql :stereo
        end

      end

      describe "#sample_rate" do

        it "delegates to mp3_data" do
          allow(mp3_data).to receive(:sample_rate).and_return(44100)
          expect(decoder.sample_rate).to eql 44100
        end

      end

    end

  end
end
