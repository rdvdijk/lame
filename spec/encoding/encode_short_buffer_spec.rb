require 'spec_helper'

module LAME
  module Encoding

    shared_examples_for "a stereo buffer encoder" do
      # stubbing galore!

      let(:framesize) { 1152 }
      let(:left) { stub(:size => framesize) }
      let(:right) { stub }
      let(:global_flags) { stub }
      let(:configuration) { stub(Configuration, :global_flags => global_flags, :framesize => framesize, :output_buffer_size => 8640) }

      subject(:encoder) { described_class.new(configuration) }

      it "creates input buffers" do
        LAME.stub(lame_function).and_return(0)

        Buffer.should_receive(:create).with(data_type, left)
        Buffer.should_receive(:create).with(data_type, right)

        encoder.encode_frame(left, right)
      end

      it "creates output buffer" do
        LAME.stub(lame_function).and_return(0)

        Buffer.stub(:create)
        Buffer.should_receive(:create_empty).with(:uchar, 8640).and_return(stub.as_null_object)

        encoder.encode_frame(left, right)
      end

      it "encodes the input" do
        left_stub = stub("left")
        right_stub = stub("right")
        output_stub = stub("output", :get_bytes => [])

        Buffer.stub(:create).with(data_type, left).and_return(left_stub)
        Buffer.stub(:create).with(data_type, right).and_return(right_stub)
        Buffer.stub(:create_empty).with(:uchar, 8640).and_return(output_stub)

        LAME.should_receive(lame_function) do |flags, left_buffer, right_buffer, framesize, output, output_size|
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
        LAME.stub(lame_function).and_return(512)

        mp3_data = stub
        output = stub
        output.stub(:get_bytes).with(0, 512).and_return(mp3_data)

        Buffer.stub(:create)
        Buffer.stub(:create_empty).with(:uchar, 8640).and_return(output)

        encoder.encode_frame(left, right).should eql mp3_data
      end
    end

    describe ShortBufferEncoder do
      it_should_behave_like "a stereo buffer encoder" do
        let(:data_type) { :short }
        let(:lame_function) { :lame_encode_buffer }
      end
    end

    describe FloatBufferEncoder do
      it_should_behave_like "a stereo buffer encoder" do
        let(:data_type) { :float }
        let(:lame_function) { :lame_encode_buffer_ieee_float }
      end
    end

    describe LongBufferEncoder do
      it_should_behave_like "a stereo buffer encoder" do
        let(:data_type) { :long }
        let(:lame_function) { :lame_encode_buffer_long2 }
      end
    end
  end
end
