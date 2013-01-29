module LAME
  class Configuration
    extend Delegation

    attr_reader :global_flags

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

    def initialize(global_flags)
      @global_flags = global_flags
    end

  end
end
