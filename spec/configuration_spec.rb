require 'spec_helper'

module LAME
  describe Configuration do

    context "intialization" do
      let(:global_flags) { stub }

      it "initializes with global flags" do
        configuration = Configuration.new(global_flags)
        configuration.global_flags.should eql global_flags
      end

      it "initializes a AsmOptimization configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::AsmOptimization.should_receive(:new).with(global_flags)
        configuration.asm_optimization
      end

      it "memoizes one AsmOptimization configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::AsmOptimization.stub(:new).and_return(stub)
        Configuration::AsmOptimization.should_receive(:new).exactly(:once)
        configuration.asm_optimization
        configuration.asm_optimization
      end

      it "initializes a Id3 configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::Id3.should_receive(:new).with(global_flags)
        configuration.id3
      end

      it "memoizes one Id3 configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::Id3.stub(:new).and_return(stub)
        Configuration::Id3.should_receive(:new).exactly(:once)
        configuration.id3
        configuration.id3
      end

      it "initializes a Quantization configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::Quantization.should_receive(:new).with(global_flags)
        configuration.quantization
      end

      it "memoizes one Quantization configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::Quantization.stub(:new).and_return(stub)
        Configuration::Quantization.should_receive(:new).exactly(:once)
        configuration.quantization
        configuration.quantization
      end

      it "initializes a VBR configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::VBR.should_receive(:new).with(global_flags)
        configuration.vbr
      end

      it "memoizes one VBR configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::VBR.stub(:new).and_return(stub)
        Configuration::VBR.should_receive(:new).exactly(:once)
        configuration.vbr
        configuration.vbr
      end

      it "initializes a Filtering configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::Filtering.should_receive(:new).with(global_flags)
        configuration.filtering
      end

      it "memoizes one Filtering configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::Filtering.stub(:new).and_return(stub)
        Configuration::Filtering.should_receive(:new).exactly(:once)
        configuration.filtering
        configuration.filtering
      end

      it "initializes a PsychoAcoustics configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::PsychoAcoustics.should_receive(:new).with(global_flags)
        configuration.psycho_acoustics
      end

      it "memoizes one PsychoAcoustics configuration object" do
        configuration = Configuration.new(global_flags)

        Configuration::PsychoAcoustics.stub(:new).and_return(stub)
        Configuration::PsychoAcoustics.should_receive(:new).exactly(:once)
        configuration.psycho_acoustics
        configuration.psycho_acoustics
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

      context "basic fields" do

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
        it { should delegate(:copyright) }
        it { should delegate(:original) }
        it { should delegate(:error_protection) }
        it { should delegate(:extension) }
        it { should delegate(:force_short_blocks) }
        it { should delegate(:emphasis) }

        it "delegates .preset= to #lame_set_preset" do
          preset = stub
          LAME.should_receive(:lame_set_preset).with(global_flags, preset)
          configuration.preset = preset
        end

      end

      context "asm_optimization fields" do
        subject(:asm_optimization) { configuration.asm_optimization }

        it "delegates .mmx to #lame_set_asm_optimizations" do
          LAME.should_receive(:lame_set_asm_optimizations).with(global_flags, :MMX, 1)
          asm_optimization.mmx = true
        end

        it "delegates .amd_3dnow to #lame_set_asm_optimizations" do
          LAME.should_receive(:lame_set_asm_optimizations).with(global_flags, :AMD_3DNOW, 1)
          asm_optimization.amd_3dnow = true
        end

        it "delegates .sse to #lame_set_asm_optimizations" do
          LAME.should_receive(:lame_set_asm_optimizations).with(global_flags, :SSE, 1)
          asm_optimization.sse = true
        end
      end

      context "id3 fields" do
        subject(:id3) { configuration.id3 }

        it "delegates .v2 to #id3tag_add_v2" do
          LAME.should_receive(:id3tag_add_v2).with(global_flags)
          id3.v2 = true
        end

        it "delegates .v1_only to #id3tag_v1_only" do
          LAME.should_receive(:id3tag_v1_only).with(global_flags)
          id3.v1_only = true
        end

        it "delegates .v2_only to #id3tag_v2_only" do
          LAME.should_receive(:id3tag_v2_only).with(global_flags)
          id3.v2_only = true
        end

        it "delegates .v1_space to #id3tag_v1_space" do
          LAME.should_receive(:id3tag_space_v1).with(global_flags)
          id3.v1_space = true
        end

        it "delegates .v2_padding to #id3tag_pad_v2" do
          LAME.should_receive(:id3tag_pad_v2).with(global_flags)
          id3.v2_padding = true
        end

        it "delegates .v2_padding_size to #id3tag_set_pad" do
          value = stub
          LAME.should_receive(:id3tag_set_pad).with(global_flags, value)
          id3.v2_padding_size = value
        end
      end

      context "quantization fields" do
        subject(:quantization) { configuration.quantization }

        it { should delegate(:comp).to(:quant_comp) }
        it { should delegate(:comp_short).to(:quant_comp_short) }
        it { should delegate(:experimental_x).to(:experimentalX) }
        it { should delegate(:experimental_y).to(:experimentalY) }
        it { should delegate(:experimental_z).to(:experimentalZ) }
        it { should delegate(:naoki).to(:exp_nspsytune) }
        it { should delegate(:msfix) }

        it "delegates .reservoir= to #lame_set_disable_reservoir" do
          LAME.should_receive(:lame_set_disable_reservoir).with(global_flags, 1)
          quantization.reservoir = false
        end

        it "delegates .reservoir to #lame_get_disable_reservoir" do
          LAME.should_receive(:lame_get_disable_reservoir).with(global_flags)
          quantization.reservoir
        end
      end

      context "vbr" do
        subject(:vbr) { configuration.vbr }

        it { should delegate(:write_tag).to(:bWriteVbrTag) }
        it { should delegate(:mode).to(:VBR) }
        it { should delegate(:q).to(:VBR_q) }
        it { should delegate(:quality).to(:VBR_quality) }
        it { should delegate(:mean_bitrate).to(:VBR_mean_bitrate_kbps) }
        it { should delegate(:min_bitrate).to(:VBR_min_bitrate_kbps) }
        it { should delegate(:max_bitrate).to(:VBR_max_bitrate_kbps) }
        it { should delegate(:enforce_min_bitrate).to(:VBR_hard_min) }
      end

      context "filtering" do
        subject(:filtering) { configuration.filtering }

        it { should delegate(:low_pass_frequency).to(:lowpassfreq) }
        it { should delegate(:low_pass_width).to(:lowpasswidth) }
        it { should delegate(:high_pass_frequency).to(:highpassfreq) }
        it { should delegate(:high_pass_width).to(:highpasswidth) }
      end

      context "psycho acoustics" do
        subject(:psycho_acoustics) { configuration.psycho_acoustics }

        it { should delegate(:ath_only).to(:ATHonly) }
        it { should delegate(:ath_short).to(:ATHshort) }
        it { should delegate(:ath_type).to(:ATHtype) }
        it { should delegate(:ath_lower).to(:ATHlower) }
        it { should delegate(:athaa_type) }
        it { should delegate(:athaa_sensitivity) }

        it "delegates .ath= to #lame_set_noATH" do
          LAME.should_receive(:lame_set_noATH).with(global_flags, 1)
          psycho_acoustics.ath = false
        end

        it "delegates .ath to #lame_get_noATH" do
          LAME.should_receive(:lame_get_noATH).with(global_flags)
          psycho_acoustics.ath
        end
      end

    end

  end
end
