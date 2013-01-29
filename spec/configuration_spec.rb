require 'spec_helper'

module LAME
  describe Configuration do

    context "intialization" do
      it "initializes with global flags" do
        global_flags = stub
        configuration = Configuration.new(global_flags)
        configuration.global_flags.should eql global_flags
      end
    end

    # More ruby-ish accessors:
    #
    # encoder = LAME::Encoder.new
    # encoder.number_of_samples = 100
    #
    # Delegates to `LAME.lame_set_num_samples(global_flags, 100)`
    # 
    context "set/get delegation" do

      let(:global_flags) { stub(GlobalFlags) }
      subject(:configuration) { Configuration.new(global_flags) }

      it { should delegate(:number_of_samples).to(:num_samples) }
      it { should delegate(:number_of_channels).to(:num_channels) }
      it { should delegate(:input_samplerate).to(:in_samplerate) }
      it { should delegate(:output_samplerate).to(:out_samplerate) }
      it { should delegate(:force_mid_side).to(:force_ms) }
      it { should delegate(:replay_gain).to(:findReplayGain) }
      it { should delegate(:bitrate).to(:brate) }
      it { should delegate(:strict_iso).to(:strict_ISO) }
      it { should delegate(:allow_different_block_types).to(:allow_diff_short) }
      it { should delegate(:temporal_masking).to(:useTemporal) }
      it { should delegate(:inter_channel_ratio).to(:interChRatio) }
      it { should delegate(:disable_short_blocks).to(:no_short_blocks) }

      it { should delegate(:scale) }
      it { should delegate(:scale_left) }
      it { should delegate(:scale_right) }
      it { should delegate(:analysis) }
      it { should delegate(:decode_only) }
      it { should delegate(:quality) }
      it { should delegate(:mode) }
      it { should delegate(:free_format) }
      it { should delegate(:decode_on_the_fly) }
      it { should delegate(:preset) }
      it { should delegate(:copyright) }
      it { should delegate(:original) }
      it { should delegate(:error_protection) }
      it { should delegate(:extension) }
      it { should delegate(:force_short_blocks) }
      it { should delegate(:emphasis) }

    end

  end
end
