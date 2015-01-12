require 'spec_helper'

module LAME
  module Decoding
    describe StreamDecoder do

      subject(:decoder) { StreamDecoder.new(decode_flags, mp3_data, stream) }

      let(:decode_flags) { double("decode flags") }
      let(:mp3_data) { double("mp3 data") }

      let(:stream) { StringIO.new(stream_string) }
      let(:stream_string) { "a" * 1024 + "b" * 1024}

      it "creates a single frame decoder" do
        expect(SingleFrameDecoder).to receive(:new).with(decode_flags, mp3_data)
        decoder
      end

      it "it passes chunks of stream into the single frame decoder" do
        single_frame_decoder = double("single_frame_decoder")
        allow(SingleFrameDecoder).to receive(:new).and_return(single_frame_decoder)

        expect(single_frame_decoder).to receive(:decode).exactly(:twice)

        decoder.each_decoded_frame
      end

      it "yields the decoded frame" do
        single_frame_decoder = double("single frame decoder")
        allow(SingleFrameDecoder).to receive(:new).and_return(single_frame_decoder)

        allow(single_frame_decoder).to receive(:decode).with("a"*1024).and_yield(:one)
        allow(single_frame_decoder).to receive(:decode).with("b"*1024).and_yield(:two).and_yield(:three)

        expect { |block|
          decoder.each_decoded_frame(&block)
        }.to yield_successive_args(:one, :two, :three)
      end

    end
  end
end
