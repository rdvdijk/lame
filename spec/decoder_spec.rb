require 'spec_helper'

module LAME
  describe Decoder do

    let(:decode_flags)           { stub("decode flags") }
    let(:mp3_file)               { stub("mp3 file") }
    let(:id3_tag_parser)         { stub("id3 tag parser", :skip! => nil) }
    let(:mp3_data_header_parser) { stub("mp3 data header parser", :parse! => nil) }

    # Stub away all collaborators:
    before do
      Decoding::Id3TagParser.stub(:new).and_return(id3_tag_parser)
      Decoding::Mp3DataHeaderParser.stub(:new).and_return(mp3_data_header_parser)
      FFI::DecodeFlags.stub(:new).and_return(decode_flags)
    end

    subject(:decoder) { Decoder.new(mp3_file) }

    context "initialization" do

      it "initializes DecodeFlags" do
        FFI::DecodeFlags.should_receive(:new)
        Decoder.new(mp3_file)
      end

      it "has the DecodeFlags" do
        decode_flags = stub
        FFI::DecodeFlags.stub(:new).and_return(decode_flags)
        decoder.decode_flags.should eql decode_flags
      end

      it "has the mp3 file path" do
        decoder.mp3_file.should eql mp3_file
      end

      it "skips the id3 offset" do
        Decoding::Id3TagParser.should_receive(:new).with(mp3_file)
        id3_tag_parser.should_receive(:skip!)

        decoder
      end

      it "parses the mp3 data header" do
        parser = stub
        mp3_data = stub
        Decoding::Mp3DataHeaderParser.should_receive(:new).with(decode_flags, mp3_file).and_return(parser)
        parser.should_receive(:parse!).and_return(mp3_data)

        decoder.mp3_data.should eql mp3_data
      end

    end

    describe "#each_frame" do

      let(:stream_decoder) { stub }
      before do
        Decoding::StreamDecoder.stub(:new).and_return(stream_decoder)
      end

      # stubbing galore!
      it "initializes a stream decoder with mp3 file and mp3 data" do
        stream_decoder.stub(:each_frame)

        mp3_data = stub
        parser = stub

        Decoding::Mp3DataHeaderParser.stub(:new).and_return(parser)
        parser.stub(:parse!).and_return(mp3_data)

        Decoding::StreamDecoder.should_receive(:new).with(mp3_file, mp3_data)

        decoder.each_frame
      end

      it "delegates to a stream decoder" do
        stream_decoder.should_receive(:each_frame)

        decoder.each_frame
      end

      it "re-yields the stream decoder's yield" do
        stream_decoder.stub(:each_frame).and_yield(:one).and_yield(:two)

        expect { |block|
          decoder.each_frame(&block)
        }.to yield_successive_args(:one, :two)
      end

    end

  end
end
