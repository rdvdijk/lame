require 'spec_helper'

module LAME
  module Encoding
    describe Id3 do

      let(:global_flags) { double }
      let(:configuration) { double(Configuration, :global_flags => global_flags, :framesize => 1152, :output_buffer_size => 8640) }

      subject(:id3) { Id3.new(configuration) }

      describe "#v1" do
        it "creates empty and filled output buffer" do
          allow(LAME).to receive(:lame_get_id3v1_tag).and_return(1024, 1024)

          # Determine size
          expect(Buffer).to receive(:create_empty).with(:uchar, 0).and_return(double.as_null_object)

          # Actual tag
          expect(Buffer).to receive(:create_empty).with(:uchar, 1024).and_return(double.as_null_object)

          id3.v1
        end

        it "creates tag" do
          # Determine size
          expect(LAME).to receive(:lame_get_id3v1_tag) do |flags, buffer, buffer_size|
            expect(flags).to       eql global_flags
            expect(buffer.size).to eql 0
            expect(buffer_size).to eql 0
            1024
          end

          # Get actual tag
          expect(LAME).to receive(:lame_get_id3v1_tag) do |flags, buffer, buffer_size|
            expect(flags).to       eql global_flags
            expect(buffer.size).to eql 1024
            expect(buffer_size).to eql 1024
          end

          id3.v1
        end

        it "returns the id3 tag" do
          allow(LAME).to receive(:lame_get_id3v1_tag).and_return(512, 512)

          mp3_data = double("mp3_data")
          output = double("output")
          allow(output).to receive(:get_bytes).with(0, 512).and_return(mp3_data)

          allow(Buffer).to receive(:create_empty).with(:uchar, 0)
          allow(Buffer).to receive(:create_empty).with(:uchar, 512).and_return(output)

          expect(id3.v1).to eql mp3_data
        end
      end

      describe "#v2" do
        it "creates empty and filled output buffer" do
          allow(LAME).to receive(:lame_get_id3v2_tag).and_return(1024, 1024)

          # Determine size
          expect(Buffer).to receive(:create_empty).with(:uchar, 0).and_return(double.as_null_object)

          # Actual tag
          expect(Buffer).to receive(:create_empty).with(:uchar, 1024).and_return(double.as_null_object)

          id3.v2
        end

        it "creates tag" do
          # Determine size
          expect(LAME).to receive(:lame_get_id3v2_tag) do |flags, buffer, buffer_size|
            expect(flags).to       eql global_flags
            expect(buffer.size).to eql 0
            expect(buffer_size).to eql 0
            1024
          end

          # Get actual tag
          expect(LAME).to receive(:lame_get_id3v2_tag) do |flags, buffer, buffer_size|
            expect(flags).to       eql global_flags
            expect(buffer.size).to eql 1024
            expect(buffer_size).to eql 1024
          end

          id3.v2
        end

        it "returns the id3 tag" do
          allow(LAME).to receive(:lame_get_id3v2_tag).and_return(512, 512)

          mp3_data = double("mp3_data")
          output = double("output")
          allow(output).to receive(:get_bytes).with(0, 512).and_return(mp3_data)

          allow(Buffer).to receive(:create_empty).with(:uchar, 0)
          allow(Buffer).to receive(:create_empty).with(:uchar, 512).and_return(output)

          expect(id3.v2).to eql mp3_data
        end
      end

    end
  end
end
