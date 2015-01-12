require 'spec_helper'

module LAME
  module Encoding

    shared_examples_for "a stereo buffer encoder" do
      # stubbing galore!

      let(:framesize) { 1152 }
      let(:left) { double("left", :size => framesize) }
      let(:right) { double("right") }
      let(:global_flags) { double("global_flags") }
      let(:configuration) { double(Configuration, :global_flags => global_flags, :framesize => framesize, :output_buffer_size => 8640) }

      subject(:encoder) { described_class.new(configuration) }

      it "creates input buffers" do
        allow(LAME).to receive(lame_function).and_return(0)

        expect(Buffer).to receive(:create).with(data_type, left)
        expect(Buffer).to receive(:create).with(data_type, right)

        encoder.encode_frame(left, right)
      end

      it "creates output buffer" do
        allow(LAME).to receive(lame_function).and_return(0)

        allow(Buffer).to receive(:create)
        expect(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(double.as_null_object)

        encoder.encode_frame(left, right)
      end

      it "encodes the input" do
        left_double = double("left")
        right_double = double("right")
        output_double = double("output", :get_bytes => [])

        allow(Buffer).to receive(:create).with(data_type, left).and_return(left_double)
        allow(Buffer).to receive(:create).with(data_type, right).and_return(right_double)
        allow(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(output_double)

        expect(LAME).to receive(lame_function) do |flags, left_buffer, right_buffer, framesize, output, output_size|
          expect(flags).to        eql global_flags
          expect(left_buffer).to  eql left_double
          expect(right_buffer).to eql right_double
          expect(framesize).to    eql 1152
          expect(output).to       eql output_double
          expect(output_size).to  eql 8640

          0 # return value
        end

        encoder.encode_frame(left, right)
      end

      it "returns the encoded data" do
        allow(LAME).to receive(lame_function).and_return(512)

        mp3_data = double("mp3_data")
        output = double("output")
        allow(output).to receive(:get_bytes).with(0, 512).and_return(mp3_data)

        allow(Buffer).to receive(:create)
        allow(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(output)

        expect(encoder.encode_frame(left, right)).to eql mp3_data
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
