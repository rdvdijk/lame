require 'spec_helper'

module LAME
  module Decoding
    describe SingleFrameDecoder do

      subject(:decoder) { SingleFrameDecoder.new(decode_flags, mp3_data) }

      let(:decode_flags) { stub("decode flags") }
      let(:mp3_data) { stub("mp3 data") }
      let(:data) { "a"*1024 }

      it "always checks if there is a frame in the internal buffer" do
        # initial frame
        LAME.should_receive(:hip_decode1_headers) do |flags, in_buffer, in_size, out_left, out_right, mp3_data_arg|
          flags.should          eql decode_flags
          in_buffer.size.should eql 0
          in_size.should        eql 0
          out_left.size.should  eql 1152*2 # short is 2 bytes
          out_right.size.should eql 1152*2
          mp3_data_arg.should   eql mp3_data
          0
        end
        # new data
        LAME.stub(:hip_decode1_headers).and_return(0)

        decoder.decode(data)
      end

      it "writes the input data into the LAME decoder" do
        # initial
        LAME.should_receive(:hip_decode1_headers) do |_, in_buffer, _, _ , _, _|
          in_buffer.size.should eql 0
          0
        end
        # new data
        LAME.should_receive(:hip_decode1_headers) do |flags, in_buffer, in_size, out_left, out_right, mp3_data_arg|
          flags.should          eql decode_flags
          in_buffer.size.should eql 1024
          in_size.should        eql 1024
          out_left.size.should  eql 1152*2 # short is 2 bytes
          out_right.size.should eql 1152*2
          mp3_data_arg.should   eql mp3_data
          0
        end

        decoder.decode(data)
      end

      it "decodes until no more frames were decoded" do
        LAME.stub(:hip_decode1_headers).and_return(0, 1, 1, 0)
        LAME.should_receive(:hip_decode1_headers).exactly(4).times

        decoder.decode(data) {}
      end

      it "yields frames for initial decoded frame" do
        LAME.stub(:hip_decode1_headers).and_return(1, 0)

        expect { |block|
          decoder.decode(data, &block)
        }.to yield_control
      end

      it "yields frames for successive frames" do
        LAME.stub(:hip_decode1_headers).and_return(0, 1, 0)

        expect { |block|
          decoder.decode(data, &block)
        }.to yield_control
      end

      it "raises an error if decoding failed" do
        LAME.stub(:hip_decode1_headers).and_return(-1)

        expect {
          decoder.decode(data)
        }.to raise_error(DecodingError)
      end

      # Enable this test once next rspec-expectations have been released
      xit "yields until no more data is decoded" do
        LAME.stub(:hip_decode1_headers).and_return(0, 1, 1, 0)

        LAME.should_receive(:hip_decode1_headers).exactly(4).times

        expect {
          decoder.decode(data)
        }.to yield_control.exactly(2).times
      end

      xit "yields if the decoder had a decoded frame initially" do
        LAME.stub(:hip_decode1_headers).and_return(1, 1, 1, 0)

        LAME.should_receive(:hip_decode1_headers).exactly(4).times

        expect {
          decoder.decode(data)
        }.to yield_control.exactly(3).times
      end

    end
  end
end
