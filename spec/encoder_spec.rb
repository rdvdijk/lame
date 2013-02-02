require 'spec_helper'

module LAME
  describe Encoder do

    subject(:encoder) { Encoder.new }

    context "intialization" do

      it "initializes GlobalFlags" do
        GlobalFlags.should_receive(:new)
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

      let(:left) { stub }
      let(:right) { stub }
      let(:global_flags) { subject.global_flags }
      let(:configuration) { stub(Configuration) }

      before do
        Configuration.stub(:new).and_return(configuration)
        configuration.stub(:applied?).and_return(true)
        Encoders::Short.stub(:new).and_return(stub.as_null_object)
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
          Encoders::Short.stub(:new).and_return(short_encoder)
        end

        it "create a short encoder with configuration" do
          Encoders::Short.should_receive(:new).with(configuration)

          encoder.encode_short(left, right) { }
        end

        it "delegates encoding to the short encoder" do
          short_encoder.should_receive(:encode_frame).with(left, right)

          encoder.encode_short(left, right) { }
        end

        it "delegates multiple times for large input"

        it "yields the encoder results" do
          mp3_data = stub
          short_encoder.stub(:encode_frame).and_return(mp3_data)

          expect { |block|
            encoder.encode_short(left, right, &block)
          }.to yield_with_args(mp3_data)
        end

        it "yields multiple times for large input"

      end
    end

    context "flushing" do

      let(:global_flags) { subject.global_flags }
      let(:configuration) { stub(Configuration) }
      let(:flusher) { stub(Flusher).as_null_object }

      before do
        Configuration.stub(:new).and_return(configuration)
        configuration.stub(:applied?).and_return(true)
        Flusher.stub(:new).and_return(flusher)
      end

      it "creates a flusher" do
        Flusher.should_receive(:new).with(configuration)
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
      let(:vbr_info) { stub(VBRInfo).as_null_object }

      before do
        Configuration.stub(:new).and_return(configuration)
        configuration.stub(:applied?).and_return(true)
        VBRInfo.stub(:new).and_return(vbr_info)
      end

      it "creates vbr info" do
        VBRInfo.should_receive(:new).with(configuration)
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

  end
end
