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

      it "initializes a Configuration object" do
        Configuration.should_receive(:new).with(kind_of(GlobalFlags))
        encoder.configure { }
      end

      it "yields the Configuration object" do
        configuration = stub
        Configuration.stub(:new).and_return(configuration)

        expect { |block|
          encoder.configure(&block)
        }.to yield_with_args(configuration)
      end

      it "assigns the Configuration object" do
        configuration = stub
        Configuration.stub(:new).and_return(configuration)
        encoder.configure { }
        encoder.configuration.should eql configuration
      end

    end

  end
end
