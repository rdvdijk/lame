require 'spec_helper'

module LAME
  describe Id3 do

    let(:global_flags) { stub }
    let(:configuration) { stub(Configuration, :global_flags => global_flags, :framesize => 1152, :output_buffer_size => 8640) }

    subject(:id3) { Id3.new(configuration) }

    describe "#v1" do
      it "creates empty and filled output buffer" do
        LAME.stub(:lame_get_id3v1_tag).and_return(1024, 1024)

        # Determine size
        Buffer.should_receive(:create_empty).with(:uchar, 0).and_return(stub.as_null_object)

        # Actual tag
        Buffer.should_receive(:create_empty).with(:uchar, 1024).and_return(stub.as_null_object)

        id3.v1
      end

      it "creates tag" do
        # Determine size
        LAME.should_receive(:lame_get_id3v1_tag) do |flags, buffer, buffer_size|
          flags.should       eql global_flags
          buffer.size.should eql 0
          buffer_size.should eql 0
          1024
        end

        # Get actual tag
        LAME.should_receive(:lame_get_id3v1_tag) do |flags, buffer, buffer_size|
          flags.should       eql global_flags
          buffer.size.should eql 1024
          buffer_size.should eql 1024
        end

        id3.v1
      end

      it "returns the id3 tag" do
        LAME.stub(:lame_get_id3v1_tag).and_return(512, 512)

        mp3_data = stub
        output = stub
        output.stub(:get_bytes).with(0, 512).and_return(mp3_data)

        Buffer.stub(:create_empty).with(:uchar, 0)
        Buffer.stub(:create_empty).with(:uchar, 512).and_return(output)

        id3.v1.should eql mp3_data
      end
    end

    describe "#v2" do
      it "creates empty and filled output buffer" do
        LAME.stub(:lame_get_id3v2_tag).and_return(1024, 1024)

        # Determine size
        Buffer.should_receive(:create_empty).with(:uchar, 0).and_return(stub.as_null_object)

        # Actual tag
        Buffer.should_receive(:create_empty).with(:uchar, 1024).and_return(stub.as_null_object)

        id3.v2
      end

      it "creates tag" do
        # Determine size
        LAME.should_receive(:lame_get_id3v2_tag) do |flags, buffer, buffer_size|
          flags.should       eql global_flags
          buffer.size.should eql 0
          buffer_size.should eql 0
          1024
        end

        # Get actual tag
        LAME.should_receive(:lame_get_id3v2_tag) do |flags, buffer, buffer_size|
          flags.should       eql global_flags
          buffer.size.should eql 1024
          buffer_size.should eql 1024
        end

        id3.v2
      end

      it "returns the id3 tag" do
        LAME.stub(:lame_get_id3v2_tag).and_return(512, 512)

        mp3_data = stub
        output = stub
        output.stub(:get_bytes).with(0, 512).and_return(mp3_data)

        Buffer.stub(:create_empty).with(:uchar, 0)
        Buffer.stub(:create_empty).with(:uchar, 512).and_return(output)

        id3.v2.should eql mp3_data
      end
    end

  end
end
