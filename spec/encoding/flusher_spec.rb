require 'spec_helper'

module LAME
  module Encoding
    describe Flusher do

      let(:global_flags) { double("global_flags") }
      let(:configuration) { double(Configuration, :global_flags => global_flags, :framesize => 1152, :output_buffer_size => 8640) }

      subject(:flusher) { Flusher.new(configuration) }

      it "creates output buffer" do
        allow(LAME).to receive(:lame_encode_flush).and_return(0)

        expect(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(double.as_null_object)

        flusher.flush
      end

      it "flushes" do
        output_double = double("output", :get_bytes => [])
        allow(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(output_double)

        expect(LAME).to receive(:lame_encode_flush) do |flags, buffer, buffer_size|
          expect(flags).to       eql global_flags
          expect(buffer).to      eql output_double
          expect(buffer_size).to eql 8640
        end

        flusher.flush
      end

      it "returns the flushed data" do
        allow(LAME).to receive(:lame_encode_flush).and_return(512)

        mp3_data = double("mp3_data")
        output = double("output")
        allow(output).to receive(:get_bytes).with(0, 512).and_return(mp3_data)

        allow(Buffer).to receive(:create_empty).with(:uchar, 8640).and_return(output)

        expect(flusher.flush).to eql mp3_data
      end

    end
  end
end
