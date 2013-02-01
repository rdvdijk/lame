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
        # configuration.stub(:framesize).and_return(1152)

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

      it "flushes the final frame"

    end

    context "lametag frame" do

      it "creates a 'lametag' frame with VBR info"

    end

  end
end
