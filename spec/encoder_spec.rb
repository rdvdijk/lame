require 'spec_helper'

module LAME
  describe Encoder do

    context "intialization" do

      it "initializes GlobalFlags" do
        GlobalFlags.should_receive(:new)
        Encoder.new
      end

    end

    # More ruby-ish accessors:
    #
    # encoder = LAME::Encoder.new
    # encoder.number_of_samples = 100
    #
    # Delegates to `LAME.lame_set_num_samples(global_flasg, 100)`
    # 
    context "set/get delegation" do

      let(:global_flags) { stub(GlobalFlags) }

      before do
        GlobalFlags.stub(:new) { global_flags }
      end

      {
        :number_of_samples => :num_samples,
        :input_samplerate  => :in_samplerate
      }.each_pair do |from, to|

        describe "delegate ##{from} to ##{to}" do

          it "delegates ##{from}= to lame_set_#{to}" do
            value = stub
            LAME.should_receive(:"lame_set_#{to}").with(global_flags, value)
            subject.send(:"#{from}=", value)
          end

          it "delegates ##{from} to lame_get_#{to}" do
            LAME.should_receive(:"lame_get_#{to}").with(global_flags)
            subject.send(:"#{from}")
          end

        end

      end

    end

  end
end
