require "ffi"

require "lame/version"

require 'pry'

module LAME

  extend FFI::Library
  ffi_lib "libmp3lame"
  #ffi_lib "/Users/roel/code/personal/lame/lame-3.99.5/libmp3lame/.libs/libmp3lame.0.dylib"

  typedef :pointer, :global_flags

  enum :vbr_mode, [
    :vbr_off, 0,
    :vbr_mt,
    :vbr_rh,
    :vbr_abr,
    :vbr_mtrh,
    :vbr_max_indicator
    #:vbr_default, 4 # vbr_mtrh # two enums with value 4?
  ]

  class Version < FFI::Struct
    layout  :major, :int,
      :minor, :int,
      :alpha, :int,
      :beta, :int,
      :psy_major, :int,
      :psy_minor, :int,
      :psy_alpha, :int,
      :psy_beta, :int,
      :features, :string
  end

  # These `attach_function` declarations are in the order of lame.h:

  # initialization
  attach_function :lame_init, [], :global_flags

  # global flags
  attach_function :lame_set_num_samples,        [:global_flags, :ulong],  :int
  attach_function :lame_get_num_samples,        [:global_flags],          :ulong
  attach_function :lame_set_in_samplerate,      [:global_flags, :int],    :int
  attach_function :lame_get_in_samplerate,      [:global_flags],          :int
  attach_function :lame_set_num_channels,       [:global_flags, :int],    :int
  attach_function :lame_get_num_channels,       [:global_flags],          :int
  attach_function :lame_set_scale,              [:global_flags, :float],  :int
  attach_function :lame_get_scale,              [:global_flags],          :float
  attach_function :lame_set_scale_left,         [:global_flags, :float],  :int
  attach_function :lame_get_scale_left,         [:global_flags],          :float
  attach_function :lame_set_scale_right,        [:global_flags, :float],  :int
  attach_function :lame_get_scale_right,        [:global_flags],          :float
  attach_function :lame_set_out_samplerate,     [:global_flags, :int],    :int
  attach_function :lame_get_out_samplerate,     [:global_flags],          :int
  attach_function :lame_set_analysis,           [:global_flags, :int],    :int
  attach_function :lame_get_analysis,           [:global_flags],          :int
  attach_function :lame_set_bWriteVbrTag,       [:global_flags, :int],    :int
  attach_function :lame_get_bWriteVbrTag,       [:global_flags],          :int
  attach_function :lame_set_decode_only,        [:global_flags, :int],    :int
  attach_function :lame_get_decode_only,        [:global_flags],          :int
  attach_function :lame_set_quality,            [:global_flags, :int],    :int
  attach_function :lame_get_quality,            [:global_flags],          :int
  attach_function :lame_set_mode,               [:global_flags, :int],    :int
  attach_function :lame_get_mode,               [:global_flags],          :int
  attach_function :lame_set_force_ms,           [:global_flags, :int],    :int
  attach_function :lame_get_force_ms,           [:global_flags],          :int
  attach_function :lame_set_free_format,        [:global_flags, :int],    :int
  attach_function :lame_get_free_format,        [:global_flags],          :int
  attach_function :lame_set_findReplayGain,     [:global_flags, :int],    :int
  attach_function :lame_get_findReplayGain,     [:global_flags],          :int
  attach_function :lame_set_decode_on_the_fly,  [:global_flags, :int],    :int
  attach_function :lame_get_decode_on_the_fly,  [:global_flags],          :int
  attach_function :lame_set_nogap_total,        [:global_flags, :int],    :int
  attach_function :lame_get_nogap_total,        [:global_flags],          :int
  attach_function :lame_set_nogap_currentindex, [:global_flags, :int],    :int
  attach_function :lame_get_nogap_currentindex, [:global_flags],          :int
  # TODO: Callbacks
  # attach_function :lame_set_errorf,             [:global_flags, :global_flags],   :int
  # attach_function :lame_set_debugf,             [:global_flags, :global_flags],   :int
  # attach_function :lame_set_msgf,               [:global_flags, :global_flags],   :int
  attach_function :lame_set_brate,              [:global_flags, :int],    :int
  attach_function :lame_get_brate,              [:global_flags],          :int
  attach_function :lame_set_compression_ratio,  [:global_flags, :int],    :int
  attach_function :lame_get_compression_ratio,  [:global_flags],          :int
  attach_function :lame_set_preset,             [:global_flags, :int],    :int
  attach_function :lame_set_asm_optimizations,  [:global_flags, :int, :int], :int
  attach_function :lame_set_copyright,          [:global_flags, :int],    :int
  attach_function :lame_get_copyright,          [:global_flags],          :int
  attach_function :lame_set_original,           [:global_flags, :int],    :int
  attach_function :lame_get_original,           [:global_flags],          :int
  attach_function :lame_set_error_protection,   [:global_flags, :int],    :int
  attach_function :lame_get_error_protection,   [:global_flags],          :int
  attach_function :lame_set_extension,          [:global_flags, :int],    :int
  attach_function :lame_get_extension,          [:global_flags],          :int
  attach_function :lame_set_strict_ISO,         [:global_flags, :int],    :int
  attach_function :lame_get_strict_ISO,         [:global_flags],          :int

  # quantization/noise shaiping
  attach_function :lame_set_disable_reservoir, [:global_flags, :int],    :int
  attach_function :lame_get_disable_reservoir, [:global_flags],          :int
  attach_function :lame_set_quant_comp,        [:global_flags, :int],    :int
  attach_function :lame_get_quant_comp,        [:global_flags],          :int
  attach_function :lame_set_quant_comp_short,  [:global_flags, :int],    :int
  attach_function :lame_get_quant_comp_short,  [:global_flags],          :int
  attach_function :lame_set_experimentalX,     [:global_flags, :int],    :int
  attach_function :lame_get_experimentalX,     [:global_flags],          :int
  attach_function :lame_set_experimentalY,     [:global_flags, :int],    :int
  attach_function :lame_get_experimentalY,     [:global_flags],          :int
  attach_function :lame_set_experimentalZ,     [:global_flags, :int],    :int
  attach_function :lame_get_experimentalZ,     [:global_flags],          :int
  attach_function :lame_set_exp_nspsytune,     [:global_flags, :int],    :int
  attach_function :lame_get_exp_nspsytune,     [:global_flags],          :int
  attach_function :lame_set_msfix,             [:global_flags, :double], :void
  attach_function :lame_get_msfix,             [:global_flags],          :float

  # VBR
  attach_function :lame_set_VBR,                   [:global_flags, :vbr_mode], :int
  attach_function :lame_get_VBR,                   [:global_flags],            :vbr_mode
  attach_function :lame_set_VBR_q,                 [:global_flags, :int],      :int
  attach_function :lame_get_VBR_q,                 [:global_flags],            :int
  attach_function :lame_set_VBR_quality,           [:global_flags, :float],    :int
  attach_function :lame_get_VBR_quality,           [:global_flags],            :float
  attach_function :lame_set_VBR_mean_bitrate_kbps, [:global_flags, :int],      :int
  attach_function :lame_get_VBR_mean_bitrate_kbps, [:global_flags],            :int
  attach_function :lame_set_VBR_min_bitrate_kbps,  [:global_flags, :int],      :int
  attach_function :lame_get_VBR_min_bitrate_kbps,  [:global_flags],            :int
  attach_function :lame_set_VBR_max_bitrate_kbps,  [:global_flags, :int],      :int
  attach_function :lame_get_VBR_max_bitrate_kbps,  [:global_flags],            :int
  attach_function :lame_set_VBR_hard_min,          [:global_flags, :int],      :int
  attach_function :lame_get_VBR_hard_min,          [:global_flags],            :int

  # Filtering control
  attach_function :lame_set_lowpassfreq,   [:global_flags, :int], :int
  attach_function :lame_get_lowpassfreq,   [:global_flags],       :int
  attach_function :lame_set_lowpasswidth,  [:global_flags, :int], :int
  attach_function :lame_get_lowpasswidth,  [:global_flags],       :int
  attach_function :lame_set_highpassfreq,  [:global_flags, :int], :int
  attach_function :lame_get_highpassfreq,  [:global_flags],       :int
  attach_function :lame_set_highpasswidth, [:global_flags, :int], :int
  attach_function :lame_get_highpasswidth, [:global_flags],       :int

  # psycho acoustics
  attach_function :lame_set_ATHonly,           [:global_flags, :int],   :int
  attach_function :lame_get_ATHonly,           [:global_flags],         :int
  attach_function :lame_set_ATHshort,          [:global_flags, :int],   :int
  attach_function :lame_get_ATHshort,          [:global_flags],         :int
  attach_function :lame_set_noATH,             [:global_flags, :int],   :int
  attach_function :lame_get_noATH,             [:global_flags],         :int
  attach_function :lame_set_ATHtype,           [:global_flags, :int],   :int
  attach_function :lame_get_ATHtype,           [:global_flags],         :int
  attach_function :lame_set_ATHlower,          [:global_flags, :float], :int
  attach_function :lame_get_ATHlower,          [:global_flags],         :float
  attach_function :lame_set_athaa_type,        [:global_flags, :int],   :int
  attach_function :lame_get_athaa_type,        [:global_flags],         :int
  attach_function :lame_set_athaa_sensitivity, [:global_flags, :float], :int
  attach_function :lame_get_athaa_sensitivity, [:global_flags],         :float

  # blocks
  attach_function :lame_set_allow_diff_short,   [:global_flags, :int],   :int
  attach_function :lame_get_allow_diff_short,   [:global_flags],         :int
  attach_function :lame_set_useTemporal,        [:global_flags, :int],   :int
  attach_function :lame_get_useTemporal,        [:global_flags],         :int
  attach_function :lame_set_interChRatio,       [:global_flags, :float], :int
  attach_function :lame_get_interChRatio,       [:global_flags],         :float
  attach_function :lame_set_no_short_blocks,    [:global_flags, :int],   :int
  attach_function :lame_get_no_short_blocks,    [:global_flags],         :int
  attach_function :lame_set_force_short_blocks, [:global_flags, :int],   :int
  attach_function :lame_get_force_short_blocks, [:global_flags],         :int
  attach_function :lame_set_emphasis,           [:global_flags, :int],   :int
  attach_function :lame_get_emphasis,           [:global_flags],         :int

  # internal variables
  attach_function :lame_get_version,              [:global_flags], :int
  attach_function :lame_get_encoder_delay,        [:global_flags], :int
  attach_function :lame_get_encoder_padding,      [:global_flags], :int
  attach_function :lame_get_framesize,            [:global_flags], :int
  attach_function :lame_get_mf_samples_to_encode, [:global_flags], :int
  attach_function :lame_get_size_mp3buffer,       [:global_flags], :int
  attach_function :lame_get_frameNum,             [:global_flags], :int
  attach_function :lame_get_totalframes,          [:global_flags], :int
  attach_function :lame_get_RadioGain,            [:global_flags], :int
  attach_function :lame_get_AudiophileGain,       [:global_flags], :int
  attach_function :lame_get_PeakSample,           [:global_flags], :float
  attach_function :lame_get_noclipGainChange,     [:global_flags], :int
  attach_function :lame_get_noclipScale,          [:global_flags], :float

  # initializing parameters
  attach_function :lame_init_params, [:global_flags], :int

  # version
  attach_function :get_lame_version,            [], :string
  attach_function :get_lame_short_version,      [], :string
  attach_function :get_lame_very_short_version, [], :string
  attach_function :get_psy_version,             [], :string
  attach_function :get_lame_url,                [], :string
  attach_function :get_lame_os_bitness,         [], :string

  attach_function :get_lame_version_numerical,  [:global_flags], Version.by_value

  # TODO: test when we have implemented lame_set_msgf
  attach_function :lame_print_config,    [:global_flags], :void
  attach_function :lame_print_internals, [:global_flags], :void

  # encoding
  attach_function :lame_encode_buffer,                         [:global_flags, :buffer_in, :buffer_in, :int, :buffer_out, :int], :int
  attach_function :lame_encode_buffer_interleaved,             [:global_flags, :buffer_in, :buffer_in, :int, :buffer_out, :int], :int
  attach_function :lame_encode_buffer_float,                   [:global_flags, :buffer_in, :buffer_in, :int, :buffer_out, :int], :int
  attach_function :lame_encode_buffer_ieee_float,              [:global_flags, :buffer_in, :buffer_in, :int, :buffer_out, :int], :int
  attach_function :lame_encode_buffer_interleaved_ieee_float,  [:global_flags, :buffer_in,             :int, :buffer_out, :int],           :int
  attach_function :lame_encode_buffer_ieee_double,             [:global_flags, :buffer_in, :buffer_in, :int, :buffer_out, :int], :int
  attach_function :lame_encode_buffer_interleaved_ieee_double, [:global_flags, :buffer_in,             :int, :buffer_out, :int],           :int
  attach_function :lame_encode_buffer_long,                    [:global_flags, :buffer_in, :buffer_in, :int, :buffer_out, :int], :int
  attach_function :lame_encode_buffer_long2,                   [:global_flags, :buffer_in, :buffer_in, :int, :buffer_out, :int], :int
  attach_function :lame_encode_buffer_int,                     [:global_flags, :buffer_in, :buffer_in, :int, :buffer_out, :int], :int

  # flushing
  attach_function :lame_encode_flush,       [:global_flags, :pointer, :int], :int
  attach_function :lame_encode_flush_nogap, [:global_flags, :pointer, :int], :int

  # bitstream
  attach_function :lame_init_bitstream, [:global_flags], :int

  # TODO: statistics (multi-dimensional arrays..)
  # attach_function :lame_bitrate_hist,             [:global_flags, :pointer], :void
  # attach_function :lame_bitrate_kbps,             [:global_flags, :pointer], :void
  # attach_function :lame_stereo_mode_hist,         [:global_flags, :pointer], :void
  # attach_function :lame_bitrate_stereo_mode_hist, [:global_flags, :pointer], :void
  # attach_function :lame_block_type_hist,          [:global_flags, :pointer], :void
  # attach_function :lame_bitrate_block_type_hist,  [:global_flags, :pointer], :void

  # NOTE: needs a file pointer, will be deprecated (?)
  # attach_function :lame_mp3_tags_fid, [:pointer], :void

  attach_function :lame_get_lametag_frame, [:global_flags, :buffer_out, :size_t], :size_t

  # closing
  attach_function :lame_close, [:global_flags], :int

end
