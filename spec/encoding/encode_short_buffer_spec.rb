require 'spec_helper'

module LAME
  module Encoding
    describe EncodeShortBuffer do

      # stubbing galore!

      let(:framesize) { 1152 }
      let(:left) { stub(:size => framesize) }
      let(:right) { stub }
      let(:global_flags) { stub }
      let(:configuration) { stub(Configuration, :global_flags => global_flags, :framesize => framesize, :output_buffer_size => 8640) }

      subject(:encoder) { EncodeShortBuffer.new(configuration) }

      it "creates input buffers" do
        LAME.stub(:lame_encode_buffer).and_return(0)

        Buffer.should_receive(:create).with(:short, left)
        Buffer.should_receive(:create).with(:short, right)

        encoder.encode_frame(left, right)
      end

      it "creates output buffer" do
        LAME.stub(:lame_encode_buffer).and_return(0)

        Buffer.stub(:create)
        Buffer.should_receive(:create_empty).with(:uchar, 8640).and_return(stub.as_null_object)

        encoder.encode_frame(left, right)
      end

      it "encodes the input" do
        left_stub = stub("left")
        right_stub = stub("right")
        output_stub = stub("output", :get_bytes => [])

        Buffer.stub(:create).with(:short, left).and_return(left_stub)
        Buffer.stub(:create).with(:short, right).and_return(right_stub)
        Buffer.stub(:create_empty).with(:uchar, 8640).and_return(output_stub)

        LAME.should_receive(:lame_encode_buffer) do |flags, left_buffer, right_buffer, framesize, output, output_size|
          flags.should        eql global_flags
          left_buffer.should  eql left_stub
          right_buffer.should eql right_stub
          framesize.should    eql 1152
          output.should       eql output_stub
          output_size.should  eql 8640

          0 # return value
        end

        encoder.encode_frame(left, right)
      end

      it "returns the encoded data" do
        LAME.stub(:lame_encode_buffer).and_return(512)

        mp3_data = stub
        output = stub
        output.stub(:get_bytes).with(0, 512).and_return(mp3_data)

        Buffer.stub(:create)
        Buffer.stub(:create_empty).with(:uchar, 8640).and_return(output)

        encoder.encode_frame(left, right).should eql mp3_data
      end
    end
  end
end
