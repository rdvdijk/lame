require 'spec_helper'

module LAME
  describe FileEncoder do

    subject(:file_encoder) { FileEncoder.new }

    let(:source) { stub("source.wav") }
    let(:target) { stub("target.mp3") }

    before do
      # Stub away actual reading from wave file:
      reader = stub.as_null_object
      ::WaveFile::Reader.stub(:new).with(source).and_return(reader)

      # Stub away actual writing to mp3 file:
      target.stub(:write)
    end

    it "is a subclass of Encoder" do
      file_encoder.should be_an(Encoder)
    end

    it "reads the source wav file" do
      ::WaveFile::Reader.should_receive(:new).with(source)

      file_encoder.encode(source, target)
    end

    it "writes an id3v2 tag if needed" do
      v2_tag = stub(:size => 1)
      file_encoder.configuration.stub(:id3v2? => true)
      Encoding::Id3.any_instance.stub(:v2 => v2_tag)

      target.should_receive(:write).with(v2_tag).once

      file_encoder.encode(source, target)
    end

    it "does not write an id3v2 tag if not needed" do
      file_encoder.configuration.stub(:id3v2? => false)
      Encoding::Id3.should_not_receive(:new)

      file_encoder.encode(source, target)
    end

    it "writes an id3v1 tag if needed" do
      v1_tag = stub(:size => 1)
      file_encoder.configuration.stub(:id3v1? => true)
      Encoding::Id3.any_instance.stub(:v1 => v1_tag)

      target.should_receive(:write).with(v1_tag).once

      file_encoder.encode(source, target)
    end

    it "does not write an id3v1 tag if not needed" do
      file_encoder.configuration.stub(:id3v1? => false)
      Encoding::Id3.should_not_receive(:new)

      file_encoder.encode(source, target)
    end

    it "writes a vbr frame if needed" do
      vbr_frame = stub(:size => 1)
      file_encoder.configuration.stub(:vbr? => true)
      Encoding::VBRInfo.any_instance.stub(:frame => vbr_frame)

      target.should_receive(:seek).with(0)
      target.should_receive(:write).with(vbr_frame).once

      file_encoder.encode(source, target)
    end

    it "does not write a vbr frame if not needed" do
      file_encoder.configuration.stub(:vbr? => false)
      Encoding::VBRInfo.should_not_receive(:new)

      file_encoder.encode(source, target)
    end

    it "writes mp3 frames" do
    end

    it "flushes an mp3 frame"

  end
end
