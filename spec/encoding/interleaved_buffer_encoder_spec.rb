require 'spec_helper'

module LAME
  module Encoding

    shared_examples_for "a interleaved buffer encoder" do
      # stubbing galore!

      let(:framesize) { 1152 }
      let(:samples) { double("samples", :size => framesize*2) }
      let(:global_flags) { double("global_flags") }
      let(:configuration) { double(Configuration, :global_flags => global_flags, :framesize => framesize, :output_buffer_size => 8640) }

      subject(:encoder) { described_class.new(configuration) }

      it "creates input buffers" do
        allow(LAME).to receive(lame_function).and_return(0)

        expect(Buffer).to receive(:create).with(data_type, samples)

        encoder.encode_frame(samples)
      end

      it "creates output buffer" do
        allow(LAME).to receive(lame_function).and_return(0)

        allow(Buffer).to receive(:create)
        expect(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(double.as_null_object)

        encoder.encode_frame(samples)
      end

      it "encodes the input" do
        samples_stub = double("samples")
        output_stub = double("output", :get_bytes => [])

        allow(Buffer).to receive(:create).with(data_type, samples).and_return(samples_stub)
        allow(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(output_stub)

        expect(LAME).to receive(lame_function) do |flags, interleaved_buffer, framesize, output, output_size|
          expect(flags).to               eql global_flags
          expect(interleaved_buffer).to  eql samples_stub
          expect(framesize).to           eql 1152
          expect(output).to              eql output_stub
          expect(output_size).to         eql 8640

          0 # return value
        end

        encoder.encode_frame(samples)
      end

      it "returns the encoded data" do
        allow(LAME).to receive(lame_function).and_return(512)

        mp3_data = double("mp3_data")
        output = double("output")
        allow(output).to receive(:get_bytes).with(0, 512).and_return(mp3_data)

        allow(Buffer).to receive(:create)
        allow(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(output)

        expect(encoder.encode_frame(samples)).to eql mp3_data
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
