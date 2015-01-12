require 'spec_helper'

module LAME
  module Decoding
    describe SingleFrameDecoder do

      subject(:decoder) { SingleFrameDecoder.new(decode_flags, mp3_data) }

      let(:decode_flags) { double("decode flags") }
      let(:mp3_data) { double("mp3 data") }
      let(:data) { "a"*1024 }

      it "always checks if there is a decoded frame in the internal buffer" do
        # initial decoded frame
        expect(LAME).to receive(:hip_decode1_headers) do |flags, in_buffer, in_size, out_left, out_right, mp3_data_arg|
          expect(flags).to          eql decode_flags
          expect(in_buffer.size).to eql 0
          expect(in_size).to        eql 0
          expect(out_left.size).to  eql 1152*2 # short is 2 bytes
          expect(out_right.size).to eql 1152*2
          expect(mp3_data_arg).to   eql mp3_data
          0
        end
        # new data
        allow(LAME).to receive(:hip_decode1_headers).and_return(0)

        decoder.decode(data)
      end

      it "writes the input data into the LAME decoder" do
        # initial
        expect(LAME).to receive(:hip_decode1_headers) do |_, in_buffer, _, _ , _, _|
          expect(in_buffer.size).to eql 0
          0
        end
        # new data
        expect(LAME).to receive(:hip_decode1_headers) do |flags, in_buffer, in_size, out_left, out_right, mp3_data_arg|
          expect(flags).to          eql decode_flags
          expect(in_buffer.size).to eql 1024
          expect(in_size).to        eql 1024
          expect(out_left.size).to  eql 1152*2 # short is 2 bytes
          expect(out_right.size).to eql 1152*2
          expect(mp3_data_arg).to   eql mp3_data
          0
        end

        decoder.decode(data)
      end

      it "decodes until no more frames were decoded" do
        allow(LAME).to receive(:hip_decode1_headers).and_return(0, 1, 1, 0)
        expect(LAME).to receive(:hip_decode1_headers).exactly(4).times

        decoder.decode(data) {}
      end

      it "yields decoded frames if one is left in internal buffer" do
        allow(LAME).to receive(:hip_decode1_headers).and_return(1, 0)

        expect { |block|
          decoder.decode(data, &block)
        }.to yield_successive_args(DecodedFrame)
      end

      it "yields decoded frames for new data" do
        allow(LAME).to receive(:hip_decode1_headers).and_return(0, 1, 1, 0)

        expect { |block|
          decoder.decode(data, &block)
        }.to yield_successive_args(DecodedFrame, DecodedFrame)
      end

      it "raises an error if decoding failed" do
        allow(LAME).to receive(:hip_decode1_headers).and_return(-1)

        expect {
          decoder.decode(data)
        }.to raise_error(DecodingError)
      end

      it "yields until no more data is decoded" do
        allow(LAME).to receive(:hip_decode1_headers).and_return(0, 1, 1, 0)

        expect(LAME).to receive(:hip_decode1_headers).exactly(4).times

        expect { |block|
          decoder.decode(data, &block)
        }.to yield_control.exactly(2).times
      end

      # TODO: figure out expected behavior
      xit "yields if the decoder had a decoded frame " do
        allow(LAME).to receive(:hip_decode1_headers).and_return(1, 1, 1, 0)

        expect(LAME).to receive(:hip_decode1_headers).exactly(4).times

        expect { |block|
          decoder.decode(data, &block)
        }.to yield_control.exactly(3).times
      end

    end
  end
end
