require 'spec_helper'

module LAME
  module Encoding

    shared_examples_for "a interleaved buffer encoder" do
      # stubbing galore!

      let(:framesize) { 1152 }
      let(:samples) { stub(:size => framesize*2) }
      let(:global_flags) { stub }
      let(:configuration) { stub(Configuration, :global_flags => global_flags, :framesize => framesize, :output_buffer_size => 8640) }

      subject(:encoder) { described_class.new(configuration) }

      it "creates input buffers" do
        LAME.stub(lame_function).and_return(0)

        Buffer.should_receive(:create).with(data_type, samples)

        encoder.encode_frame(samples)
      end

      it "creates output buffer" do
        LAME.stub(lame_function).and_return(0)

        Buffer.stub(:create)
        Buffer.should_receive(:create_empty).with(:uchar, 8640).and_return(stub.as_null_object)

        encoder.encode_frame(samples)
      end

      it "encodes the input" do
        samples_stub = stub("samples")
        output_stub = stub("output", :get_bytes => [])

        Buffer.stub(:create).with(data_type, samples).and_return(samples_stub)
        Buffer.stub(:create_empty).with(:uchar, 8640).and_return(output_stub)

        LAME.should_receive(lame_function) do |flags, interleaved_buffer, framesize, output, output_size|
          flags.should               eql global_flags
          interleaved_buffer.should  eql samples_stub
          framesize.should           eql 1152
          output.should              eql output_stub
          output_size.should         eql 8640

          0 # return value
        end

        encoder.encode_frame(samples)
      end

      it "returns the encoded data" do
        LAME.stub(lame_function).and_return(512)

        mp3_data = stub
        output = stub
        output.stub(:get_bytes).with(0, 512).and_return(mp3_data)

        Buffer.stub(:create)
        Buffer.stub(:create_empty).with(:uchar, 8640).and_return(output)

        encoder.encode_frame(samples).should eql mp3_data
      end
    end

    describe InterleavedShortBufferEncoder do
      it_should_behave_like "a interleaved buffer encoder" do
        let(:data_type) { :short }
        let(:lame_function) { :lame_encode_buffer_interleaved }
      end
    end

    describe InterleavedFloatBufferEncoder do
      it_should_behave_like "a interleaved buffer encoder" do
        let(:data_type) { :float }
        let(:lame_function) { :lame_encode_buffer_interleaved_ieee_float }
      end
    end
  end
end
