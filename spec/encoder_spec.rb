require 'spec_helper'

module LAME
  describe Encoder do

    subject(:encoder) { Encoder.new }

    context "initialization" do

      it "initializes GlobalFlags" do
        FFI::GlobalFlags.should_receive(:new)
        Encoder.new
      end

    end

    context "configuration" do

      let(:configuration) { stub(Configuration).as_null_object }

      before do
        Configuration.stub(:new).and_return(configuration)
      end

      it "initializes a Configuration object" do
        Configuration.should_receive(:new).with(kind_of(GlobalFlags))
        encoder.configure { }
      end

      it "yields the Configuration object" do
        expect { |block|
          encoder.configure(&block)
        }.to yield_with_args(configuration)
      end

      it "assigns the Configuration object" do
        encoder.configure { }
        encoder.configuration.should eql configuration
      end

      it "applies the configuration" do
        configuration.stub(:applied?).and_return(false)
        configuration.should_receive(:apply!)
        encoder.configure { }
      end

      it "gets the framesize" do
        configuration.should_receive(:framesize).and_return(1234)
        encoder.framesize.should eql 1234
      end
    end

    context "encoding" do

      let(:left) { [0] }
      let(:right) { [0] }
      let(:global_flags) { subject.global_flags }
      let(:configuration) { stub(Configuration, :framesize => 100) }

      before do
        Configuration.stub(:new).and_return(configuration)
        configuration.stub(:applied?).and_return(true)
        Encoding::EncodeShortBuffer.stub(:new).and_return(stub.as_null_object)
      end

      it "applies the configuration if not done already" do
        configuration.stub(:applied?).and_return(false)
        configuration.should_receive(:apply!)
        encoder.encode_short(left, right) { }
      end

      it "does not apply the configuration if already applied" do
        configuration.stub(:applied?).and_return(true)
        configuration.should_not_receive(:apply!)
        encoder.encode_short(left, right) { }
      end

      context "delegation" do
        let(:short_encoder) { stub.as_null_object }

        before do
          Encoding::EncodeShortBuffer.stub(:new).and_return(short_encoder)
        end

        it "create a short encoder with configuration" do
          Encoding::EncodeShortBuffer.should_receive(:new).with(configuration)

          encoder.encode_short(left, right) { }
        end

        it "delegates encoding to the short encoder" do
          left.stub(:length => 100) # exactly framesize
          short_encoder.should_receive(:encode_frame).with(left, right)

          encoder.encode_short(left, right) { }
        end

        it "yields the encoder results" do
          mp3_data = stub
          short_encoder.stub(:encode_frame).and_return(mp3_data)

          expect { |block|
            encoder.encode_short(left, right, &block)
          }.to yield_with_args(mp3_data)
        end

        it "delegates multiple times for large input" do
          right = left = [0]*150 # larger than framesize

          short_encoder.should_receive(:encode_frame) do |left_frame, right_frame|
            left_frame.length.should eql 100
            right_frame.length.should eql 100
          end

          short_encoder.should_receive(:encode_frame) do |left_frame, right_frame|
            left_frame.length.should eql 50
            right_frame.length.should eql 50
          end

          encoder.encode_short(left, right) { }
        end

        it "yields multiple times for large input" do
          mp3_data1 = stub("frame1")
          mp3_data2 = stub("frame2")

          left = [0]*150 # larger than framesize

          short_encoder.stub(:encode_frame).and_return(mp3_data1, mp3_data2)

          expect { |block|
            encoder.encode_short(left, right, &block)
          }.to yield_successive_args(mp3_data1, mp3_data2)
        end

      end
    end

    context "flushing" do

      let(:global_flags) { subject.global_flags }
      let(:configuration) { stub(Configuration) }
      let(:flusher) { stub(Encoding::Flusher).as_null_object }

      before do
        Configuration.stub(:new).and_return(configuration)
        configuration.stub(:applied?).and_return(true)
        Encoding::Flusher.stub(:new).and_return(flusher)
      end

      it "creates a flusher" do
        Encoding::Flusher.should_receive(:new).with(configuration)
        encoder.flush { }
      end

      it "flushes the final frame" do
        flusher.should_receive(:flush)
        encoder.flush { }
      end

      it "yields the flushed mp3 data" do
        mp3_data = stub
        flusher.stub(:flush).and_return(mp3_data)

        expect { |block|
          encoder.flush(&block)
        }.to yield_with_args(mp3_data)
      end

      it "returns the flushed data if no block was given" do
        mp3_data = stub
        flusher.stub(:flush).and_return(mp3_data)
        encoder.flush.should eql mp3_data
      end

    end

    context "lametag frame" do

      let(:global_flags) { subject.global_flags }
      let(:configuration) { stub(Configuration) }
      let(:vbr_info) { stub(Encoding::VBRInfo).as_null_object }

      before do
        Configuration.stub(:new).and_return(configuration)
        configuration.stub(:applied?).and_return(true)
        Encoding::VBRInfo.stub(:new).and_return(vbr_info)
      end

      it "creates vbr info" do
        Encoding::VBRInfo.should_receive(:new).with(configuration)
        encoder.vbr_frame { }
      end

      it "creates the vbr frame" do
        vbr_info.should_receive(:frame)
        encoder.vbr_frame { }
      end

      it "yields the vbr frame" do
        mp3_data = stub
        vbr_info.stub(:frame).and_return(mp3_data)

        expect { |block|
          encoder.vbr_frame(&block)
        }.to yield_with_args(mp3_data)
      end

      it "returns the vbr frame if no block was given" do
        mp3_data = stub
        vbr_info.stub(:frame).and_return(mp3_data)
        encoder.vbr_frame.should eql mp3_data
      end

    end

    context "id3" do
      let(:global_flags) { subject.global_flags }
      let(:configuration) { stub(Configuration) }
      let(:id3) { stub(Encoding::Id3).as_null_object }

      before do
        Configuration.stub(:new).and_return(configuration)
        configuration.stub(:applied?).and_return(true)
        Encoding::Id3.stub(:new).and_return(id3)
      end

      it "creates vbr info" do
        Encoding::Id3.should_receive(:new).with(configuration)
        encoder.id3v1 { }
      end

      context "v1" do
        it "creates the id3v1 frame" do
          id3.should_receive(:v1)
          encoder.id3v1 { }
        end

        it "yields the vbr frame" do
          mp3_data = stub
          id3.stub(:v1).and_return(mp3_data)

          expect { |block|
            encoder.id3v1(&block)
          }.to yield_with_args(mp3_data)
        end

        it "returns the vbr frame if no block was given" do
          mp3_data = stub
          id3.stub(:v1).and_return(mp3_data)
          encoder.id3v1.should eql mp3_data
        end
      end

      context "v2" do
        it "creates the id3v2 frame" do
          id3.should_receive(:v2)
          encoder.id3v2 { }
        end

        it "yields the vbr frame" do
          mp3_data = stub
          id3.stub(:v2).and_return(mp3_data)

          expect { |block|
            encoder.id3v2(&block)
          }.to yield_with_args(mp3_data)
        end

        it "returns the vbr frame if no block was given" do
          mp3_data = stub
          id3.stub(:v2).and_return(mp3_data)
          encoder.id3v2.should eql mp3_data
        end
      end
    end

  end
end
