require 'spec_helper'

module LAME
  describe Decoder do

    let(:mp3_file_path) { "" }

    subject(:decoder) { Decoder.new(mp3_file_path) }

    context "initialization" do

      it "initializes DecodeFlags" do
        FFI::DecodeFlags.should_receive(:new)
        Decoder.new(mp3_file_path)
      end

      it "has the DecodeFlags" do
        decode_flags = stub
        FFI::DecodeFlags.stub(:new).and_return(decode_flags)
        decoder.decode_flags.should eql decode_flags
      end

      it "has the mp3 file path" do
        decoder.mp3_file_path.should eql mp3_file_path
      end

      it "finds the id3 offset" do
        pending
      end

      it "finds the start of mpeg audio data" do
        pending
      end

      it "parses the mp3 data header" do
        pending
      end

    end

  end
end
