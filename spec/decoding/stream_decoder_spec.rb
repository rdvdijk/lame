require 'spec_helper'

module LAME
  module Decoding
    describe StreamDecoder do

      subject(:decoder) { StreamDecoder.new(decode_flags, mp3_data, stream) }

      let(:decode_flags) { stub("decode flags") }
      let(:mp3_data) { stub("mp3 data") }

      let(:stream) { StringIO.new(stream_string) }
      let(:stream_string) { "a" * 1024 + "b" * 1024}

      it "creates a single frame decoder" do
        SingleFrameDecoder.should_receive(:new).with(decode_flags, mp3_data)
        decoder
      end

      it "it passes chunks of stream into the single frame decoder" do
        single_frame_decoder = stub
        SingleFrameDecoder.stub(:new).and_return(single_frame_decoder)

        single_frame_decoder.should_receive(:decode).exactly(:twice)

        decoder.each_frame
      end

      it "yields the decoded frames" do
        single_frame_decoder = stub
        SingleFrameDecoder.stub(:new).and_return(single_frame_decoder)

        single_frame_decoder.stub(:decode).with("a"*1024).and_yield(:one)
        single_frame_decoder.stub(:decode).with("b"*1024).and_yield(:two).and_yield(:three)

        expect { |block|
          decoder.each_frame(&block)
        }.to yield_successive_args(:one, :two, :three)
      end

    end
  end
end
