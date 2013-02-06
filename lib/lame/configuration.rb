module LAME
  class ConfigurationBase
    extend Delegation

    attr_reader :global_flags

    def initialize(global_flags)
      @global_flags = global_flags
    end

    private

    def boolean_to_int(value)
      value ? 1 : 0
    end
  end

  class Configuration < ConfigurationBase

    delegate_alias_to_lame :number_of_samples => :num_samples,
      :number_of_channels          => :num_channels,
      :input_samplerate            => :in_samplerate,
      :output_samplerate           => :out_samplerate,
      :force_mid_side              => :force_ms,
      :replay_gain                 => :findReplayGain,
      :bitrate                     => :brate,
      :strict_iso                  => :strict_ISO,
      :allow_different_block_types => :allow_diff_short,
      :temporal_masking            => :useTemporal,
      :inter_channel_ratio         => :interChRatio,
      :disable_short_blocks        => :no_short_blocks

    delegate_to_lame :scale, :scale_left, :scale_right, :analysis,
      :decode_only, :quality, :mode, :free_format, :decode_on_the_fly,
      :preset, :copyright, :original, :error_protection, :extension,
      :force_short_blocks, :emphasis

    def apply!
      init_return = LAME.lame_init_params(global_flags)
      if init_return == -1
        raise ConfigurationError
      else
        @applied = true
      end
    end

    def applied?
      @applied
    end

    def framesize
      raise ConfigurationError unless applied?
      LAME.lame_get_framesize(global_flags)
    end

    def output_buffer_size
      ((framesize * 1.25) + 7200).ceil
    end

    def asm_optimization
      @asm_optimization ||= AsmOptimization.new(global_flags)
    end

    def id3
      @id3 ||= Id3.new(global_flags)
    end

    def quantization
      @quantization ||= Quantization.new(global_flags)
    end

    def vbr
      @vbr ||= VBR.new(global_flags)
    end

    def filtering
      @filtering ||= Filtering.new(global_flags)
    end

    def psycho_acoustics
      @psycho_acoustics ||= PsychoAcoustics.new(global_flags)
    end

    class AsmOptimization < ConfigurationBase
      def mmx=(value)
        LAME.lame_set_asm_optimizations(global_flags, :MMX, boolean_to_int(value))
      end

      def amd_3dnow=(value)
        LAME.lame_set_asm_optimizations(global_flags, :AMD_3DNOW, boolean_to_int(value))
      end

      def sse=(value)
        LAME.lame_set_asm_optimizations(global_flags, :SSE, boolean_to_int(value))
      end
    end

    class Id3 < ConfigurationBase

      delegate_alias_to_lame :write_automatic => :write_id3tag_automatic

      delegate_id3_to_lame :title, :artist, :album, :year, :comment

      def initialize(global_flags)
        super(global_flags)
        LAME.id3tag_init(global_flags)
      end

      def v2=(value)
        LAME.id3tag_add_v2(global_flags) if value
      end

      def v1_only=(value)
        LAME.id3tag_v1_only(global_flags) if value
      end

      def v2_only=(value)
        LAME.id3tag_v2_only(global_flags) if value
      end

      def v1_space=(value)
        LAME.id3tag_space_v1(global_flags) if value
      end

      def v2_padding=(value)
        LAME.id3tag_pad_v2(global_flags) if value
      end

      def v2_padding_size=(size)
        LAME.id3tag_set_pad(global_flags, size)
      end

      def track=(value)
        LAME.id3tag_set_track(global_flags, value)
      end
    end

    class Quantization < ConfigurationBase
      delegate_alias_to_lame :comp => :quant_comp,
        :comp_short     => :quant_comp_short,
        :experimental_x => :experimentalX,
        :experimental_y => :experimentalY,
        :experimental_z => :experimentalZ,
        :naoki          => :exp_nspsytune

      delegate_to_lame :msfix

      def reservoir=(value)
        LAME.lame_set_disable_reservoir(global_flags, boolean_to_int(!value))
      end

      # TODO: int_to_boolean
      def reservoir
        LAME.lame_get_disable_reservoir(global_flags)
      end
    end

    class VBR < ConfigurationBase
      delegate_alias_to_lame :write_tag => :bWriteVbrTag,
        :mode                => :VBR,
        :q                   => :VBR_q,
        :quality             => :VBR_quality,
        :mean_bitrate        => :VBR_mean_bitrate_kbps,
        :min_bitrate         => :VBR_min_bitrate_kbps,
        :max_bitrate         => :VBR_max_bitrate_kbps,
        :enforce_min_bitrate => :VBR_hard_min
    end

    class Filtering < ConfigurationBase
      delegate_alias_to_lame :low_pass_frequency => :lowpassfreq,
        :low_pass_width      => :lowpasswidth,
        :high_pass_frequency => :highpassfreq,
        :high_pass_width     => :highpasswidth
    end

    class PsychoAcoustics < ConfigurationBase
      delegate_alias_to_lame :ath_only => :ATHonly,
        :ath_short => :ATHshort,
        :ath_type => :ATHtype,
        :ath_lower => :ATHlower

      delegate_to_lame :athaa_type, :athaa_sensitivity

      def ath=(value)
        LAME.lame_set_noATH(global_flags, boolean_to_int(!value))
      end

      # TODO: int_to_boolean
      def ath
        LAME.lame_get_noATH(global_flags)
      end
    end

  end
end
