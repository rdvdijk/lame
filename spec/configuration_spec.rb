require 'spec_helper'

module LAME
  describe Configuration do

    context "intialization" do
      let(:global_flags) { double("global_flags") }

      subject(:configuration) { Configuration.new(global_flags) }

      it "initializes with global flags" do
        expect(configuration.global_flags).to eql global_flags
      end

      it "initializes a AsmOptimization configuration object" do
        expect(Configuration::AsmOptimization).to receive(:new).with(global_flags)
        configuration.asm_optimization
      end

      it "memoizes one AsmOptimization configuration object" do
        allow(Configuration::AsmOptimization).to receive(:new).and_return(double)
        expect(Configuration::AsmOptimization).to receive(:new).exactly(:once)
        2.times { configuration.asm_optimization }
      end

      it "initializes a Id3 configuration object" do
        expect(Configuration::Id3).to receive(:new).with(global_flags)
        configuration.id3
      end

      it "memoizes one Id3 configuration object" do
        allow(Configuration::Id3).to receive(:new).and_return(double)
        expect(Configuration::Id3).to receive(:new).exactly(:once)
        2.times { configuration.id3 }
      end

      it "initializes a Quantization configuration object" do
        expect(Configuration::Quantization).to receive(:new).with(global_flags)
        configuration.quantization
      end

      it "memoizes one Quantization configuration object" do
        allow(Configuration::Quantization).to receive(:new).and_return(double)
        expect(Configuration::Quantization).to receive(:new).exactly(:once)
        2.times { configuration.quantization }
      end

      it "initializes a VBR configuration object" do
        expect(Configuration::VBR).to receive(:new).with(global_flags)
        configuration.vbr
      end

      it "memoizes one VBR configuration object" do
        allow(Configuration::VBR).to receive(:new).and_return(double)
        expect(Configuration::VBR).to receive(:new).exactly(:once)
        2.times { configuration.vbr }
      end

      it "initializes a Filtering configuration object" do
        expect(Configuration::Filtering).to receive(:new).with(global_flags)
        configuration.filtering
      end

      it "memoizes one Filtering configuration object" do
        allow(Configuration::Filtering).to receive(:new).and_return(double)
        expect(Configuration::Filtering).to receive(:new).exactly(:once)
        2.times { configuration.filtering }
      end

      it "initializes a PsychoAcoustics configuration object" do
        expect(Configuration::PsychoAcoustics).to receive(:new).with(global_flags)
        configuration.psycho_acoustics
      end

      it "memoizes one PsychoAcoustics configuration object" do
        allow(Configuration::PsychoAcoustics).to receive(:new).and_return(double)
        expect(Configuration::PsychoAcoustics).to receive(:new).exactly(:once)
        2.times { configuration.psycho_acoustics }
      end

      context "Id3" do

        it "initializes the Id3 tag" do
          expect(LAME).to receive(:id3tag_init).with(global_flags)
          Configuration::Id3.new(global_flags)
        end

      end

      describe "#apply! / #applied?" do
        it "is not applied by default" do
          expect(configuration).not_to be_applied
        end

        it "applies the configuration" do
          expect(LAME).to receive(:lame_init_params).with(global_flags)
          configuration.apply!
          expect(configuration).to be_applied
        end

        it "raises an error if configuration could not be applied" do
          allow(LAME).to receive(:lame_init_params).and_return(-1)
          expect {
            configuration.apply!
          }.to raise_error(ConfigurationError)
        end
      end

      describe "#framesize" do

        it "gets framesize from LAME if configuration was applied" do
          allow(LAME).to receive(:lame_init_params)
          configuration.apply!

          allow(LAME).to receive(:lame_get_framesize).and_return(42)
          expect(LAME).to receive(:lame_get_framesize).with(global_flags)
          expect(configuration.framesize).to eql 42
        end

        it "raises an error if configuration was not applied" do
          expect {
            configuration.framesize
          }.to raise_error(ConfigurationError)
        end

        it "calculates the output buffer size based on the framesize" do
          allow(LAME).to receive(:lame_init_params)
          configuration.apply!

          allow(LAME).to receive(:lame_get_framesize).and_return(1152)
          expect(LAME).to receive(:lame_get_framesize).with(global_flags)
          expect(configuration.output_buffer_size).to eql 8640
        end

      end
    end

    # More ruby-ish accessors:
    #
    #   encoder = LAME::Encoder.new
    #   encoder.number_of_samples = 100
    #
    # TODO: question-mark readers for boolean values
    #
    #   encoder.replay_gain?
    #
    # Delegates to `LAME.lame_set_num_samples(global_flags, 100)`
    # 
    context "set/get delegation" do

      let(:global_flags) { double(GlobalFlags) }
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

        it "delegates #preset= to LAME.lame_set_preset" do
          expect(LAME).to receive(:lame_set_preset).with(global_flags, anything)
          configuration.preset = double
        end

      end

      context "asm_optimization fields" do
        subject(:asm_optimization) { configuration.asm_optimization }

        it "delegates #mmx to LAME.lame_set_asm_optimizations" do
          expect(LAME).to receive(:lame_set_asm_optimizations).with(global_flags, :MMX, 1)
          asm_optimization.mmx = true
        end

        it "delegates #amd_3dnow to LAME.lame_set_asm_optimizations" do
          expect(LAME).to receive(:lame_set_asm_optimizations).with(global_flags, :AMD_3DNOW, 1)
          asm_optimization.amd_3dnow = true
        end

        it "delegates #sse to LAME.lame_set_asm_optimizations" do
          expect(LAME).to receive(:lame_set_asm_optimizations).with(global_flags, :SSE, 1)
          asm_optimization.sse = true
        end
      end

      # There are only setters for these settings:
      context "id3 fields" do
        subject(:id3) { configuration.id3 }

        it { should delegate(:write_automatic).to(:write_id3tag_automatic) }

        before do
          allow(LAME).to receive(:id3tag_init)
        end

        it "delegates #v2= to LAME.id3tag_add_v2" do
          expect(LAME).to receive(:id3tag_add_v2).with(global_flags)
          id3.v2 = true
        end

        it "delegates #v1_only= to LAME.id3tag_v1_only" do
          expect(LAME).to receive(:id3tag_v1_only).with(global_flags)
          id3.v1_only = true
        end

        it "delegates #v2_only= to LAME.id3tag_v2_only" do
          expect(LAME).to receive(:id3tag_v2_only).with(global_flags)
          id3.v2_only = true
        end

        it "delegates #v1_space= to LAME.id3tag_v1_space" do
          expect(LAME).to receive(:id3tag_space_v1).with(global_flags)
          id3.v1_space = true
        end

        it "delegates #v2_padding= to LAME.id3tag_pad_v2" do
          expect(LAME).to receive(:id3tag_pad_v2).with(global_flags)
          id3.v2_padding = true
        end

        it "delegates #v2_padding_size= to LAME.id3tag_set_pad" do
          value = double
          expect(LAME).to receive(:id3tag_set_pad).with(global_flags, value)
          id3.v2_padding_size = value
        end

        # Meta programming in a test. Oh well ;)
        [ :title, :artist, :album, :year, :comment ].each do |field|

          it "sets the #{field} with string buffer" do
            expect(LAME).to receive(:"id3tag_set_#{field}") do |flags, string_buffer|
              expect(flags).to eql global_flags
              expect(string_buffer).to be_a(::FFI::MemoryPointer)
              expect(string_buffer.get_string(0)).to eql "Some #{field}"
            end
            id3.send(:"#{field}=", "Some #{field}")
          end

        end

        it "sets the track" do
          expect(LAME).to receive(:"id3tag_set_track") do |flags, value|
            expect(flags).to eql global_flags
            expect(value).to eql 42
          end
          id3.track = 42
        end

        it "sets the genre by name" do
          expect(LAME).to receive(:id3tag_set_genre) do |flags, value|
            expect(flags).to eql global_flags
            expect(value).to be_a(::FFI::MemoryPointer)
            expect(value.get_string(0)).to eql "147"
          end
          id3.genre = "SynthPop"
        end

        it "sets the genre by id" do
          expect(LAME).to receive(:id3tag_set_genre) do |flags, value|
            expect(flags).to eql global_flags
            expect(value).to be_a(::FFI::MemoryPointer)
            expect(value.get_string(0)).to eql "81"
          end

          id3.genre = 81
        end

        it "sets non-standard genre name" do
          expect(LAME).to receive(:id3tag_set_genre) do |flags, value|
            expect(flags).to eql global_flags
            expect(value).to be_a(::FFI::MemoryPointer)
            expect(value.get_string(0)).to eql "Ruby FFI Rock"
          end
          id3.genre = "Ruby FFI Rock"
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

        it "delegates #reservoir= to LAME.lame_set_disable_reservoir" do
          expect(LAME).to receive(:lame_set_disable_reservoir).with(global_flags, 1)
          quantization.reservoir = false
        end

        it "delegates #reservoir to LAME.lame_get_disable_reservoir" do
          expect(LAME).to receive(:lame_get_disable_reservoir).with(global_flags)
          quantization.reservoir
        end

        it "delegates #reservoir? to LAME.lame_get_disable_reservoir" do
          expect(LAME).to receive(:lame_get_disable_reservoir).with(global_flags)
          quantization.reservoir?
        end

        it "converts the return value 0 for #reservoir? to false" do
          allow(LAME).to receive(:lame_get_disable_reservoir).and_return(0)
          expect(quantization.reservoir?).to be_falsy
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

        it "delegates #ath= to LAME.lame_set_noATH" do
          expect(LAME).to receive(:lame_set_noATH).with(global_flags, 1)
          psycho_acoustics.ath = false
        end

        it "delegates #ath to LAME.lame_get_noATH" do
          expect(LAME).to receive(:lame_get_noATH).with(global_flags)
          psycho_acoustics.ath
        end

        it "delegates #ath? to LAME.lame_get_noATH" do
          expect(LAME).to receive(:lame_get_noATH).with(global_flags)
          psycho_acoustics.ath?
        end

        it "converts the return value 0 for #ath? to true" do
          allow(LAME).to receive(:lame_get_noATH).and_return(0)
          expect(psycho_acoustics.ath?).to be_truthy
        end
      end

    end

  end
end
