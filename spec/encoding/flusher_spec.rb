require 'spec_helper'

module LAME
  module Encoding
    describe Flusher do

      let(:global_flags) { stub }
      let(:configuration) { stub(Configuration, :global_flags => global_flags, :framesize => 1152, :output_buffer_size => 8640) }

      subject(:flusher) { Flusher.new(configuration) }

      it "creates output buffer" do
        LAME.stub(:lame_encode_flush).and_return(0)

        Buffer.should_receive(:create_empty).with(:uchar, 8640).and_return(stub.as_null_object)

        flusher.flush
      end

      it "flushes" do
        output_stub = stub("output", :get_bytes => [])
        Buffer.stub(:create_empty).with(:uchar, 8640).and_return(output_stub)

        LAME.should_receive(:lame_encode_flush) do |flags, buffer, buffer_size|
          flags.should       eql global_flags
          buffer.should      eql output_stub
          buffer_size.should eql 8640
        end

        flusher.flush
      end

      it "returns the flushed data" do
        LAME.stub(:lame_encode_flush).and_return(512)

        mp3_data = stub
        output = stub
        output.stub(:get_bytes).with(0, 512).and_return(mp3_data)

        Buffer.stub(:create_empty).with(:uchar, 8640).and_return(output)

        flusher.flush.should eql mp3_data
      end

    end
  end
end
