require "ffi"

require "lame/version"

require 'pry'

module LAME

  extend FFI::Library
  #ffi_lib "libmp3lame"
  ffi_lib "/Users/roel/code/personal/lame/lame-3.99.5/libmp3lame/.libs/libmp3lame.0.dylib"

  VBRMode = enum :vbr_mode, [
    :vbr_off, 0,
    :vbr_mt,
    :vbr_rh,
    :vbr_abr,
    :vbr_mtrh,
    :vbr_max_indicator
    #:vbr_default, 4 # vbr_mtrh # two enums with value 4?
  ]

  # These `attach_function` declarations are in the order of lame.h:

  # initialization
  attach_function :lame_init, [], :pointer

  # global flags
  attach_function :lame_set_num_samples,        [:pointer, :ulong],  :int
  attach_function :lame_get_num_samples,        [:pointer],          :ulong
  attach_function :lame_set_in_samplerate,      [:pointer, :int],    :int
  attach_function :lame_get_in_samplerate,      [:pointer],          :int
  attach_function :lame_set_num_channels,       [:pointer, :int],    :int
  attach_function :lame_get_num_channels,       [:pointer],          :int
  attach_function :lame_set_scale,              [:pointer, :float],  :int
  attach_function :lame_get_scale,              [:pointer],          :float
  attach_function :lame_set_scale_left,         [:pointer, :float],  :int
  attach_function :lame_get_scale_left,         [:pointer],          :float
  attach_function :lame_set_scale_right,        [:pointer, :float],  :int
  attach_function :lame_get_scale_right,        [:pointer],          :float
  attach_function :lame_set_out_samplerate,     [:pointer, :int],    :int
  attach_function :lame_get_out_samplerate,     [:pointer],          :int
  attach_function :lame_set_analysis,           [:pointer, :int],    :int
  attach_function :lame_get_analysis,           [:pointer],          :int
  attach_function :lame_set_bWriteVbrTag,       [:pointer, :int],    :int
  attach_function :lame_get_bWriteVbrTag,       [:pointer],          :int
  attach_function :lame_set_decode_only,        [:pointer, :int],    :int
  attach_function :lame_get_decode_only,        [:pointer],          :int
  attach_function :lame_set_quality,            [:pointer, :int],    :int
  attach_function :lame_get_quality,            [:pointer],          :int
  attach_function :lame_set_mode,               [:pointer, :int],    :int
  attach_function :lame_get_mode,               [:pointer],          :int
  attach_function :lame_set_force_ms,           [:pointer, :int],    :int
  attach_function :lame_get_force_ms,           [:pointer],          :int
  attach_function :lame_set_free_format,        [:pointer, :int],    :int
  attach_function :lame_get_free_format,        [:pointer],          :int
  attach_function :lame_set_findReplayGain,     [:pointer, :int],    :int
  attach_function :lame_get_findReplayGain,     [:pointer],          :int
  attach_function :lame_set_decode_on_the_fly,  [:pointer, :int],    :int
  attach_function :lame_get_decode_on_the_fly,  [:pointer],          :int
  attach_function :lame_set_nogap_total,        [:pointer, :int],    :int
  attach_function :lame_get_nogap_total,        [:pointer],          :int
  attach_function :lame_set_nogap_currentindex, [:pointer, :int],    :int
  attach_function :lame_get_nogap_currentindex, [:pointer],          :int
  # TODO: Callbacks
  # attach_function :lame_set_errorf,             [:pointer, :pointer],   :int
  # attach_function :lame_set_debugf,             [:pointer, :pointer],   :int
  # attach_function :lame_set_msgf,               [:pointer, :pointer],   :int
  attach_function :lame_set_brate,              [:pointer, :int],    :int
  attach_function :lame_get_brate,              [:pointer],          :int
  attach_function :lame_set_compression_ratio,  [:pointer, :int],    :int
  attach_function :lame_get_compression_ratio,  [:pointer],          :int
  attach_function :lame_set_preset,             [:pointer, :int],    :int
  attach_function :lame_set_asm_optimizations,  [:pointer, :int, :int], :int
  attach_function :lame_set_copyright,          [:pointer, :int],    :int
  attach_function :lame_get_copyright,          [:pointer],          :int
  attach_function :lame_set_original,           [:pointer, :int],    :int
  attach_function :lame_get_original,           [:pointer],          :int
  attach_function :lame_set_error_protection,   [:pointer, :int],    :int
  attach_function :lame_get_error_protection,   [:pointer],          :int
  attach_function :lame_set_extension,          [:pointer, :int],    :int
  attach_function :lame_get_extension,          [:pointer],          :int
  attach_function :lame_set_strict_ISO,         [:pointer, :int],    :int
  attach_function :lame_get_strict_ISO,         [:pointer],          :int

  # quantization/noise shaiping
  attach_function :lame_set_disable_reservoir, [:pointer, :int],    :int
  attach_function :lame_get_disable_reservoir, [:pointer],          :int
  attach_function :lame_set_quant_comp,        [:pointer, :int],    :int
  attach_function :lame_get_quant_comp,        [:pointer],          :int
  attach_function :lame_set_quant_comp_short,  [:pointer, :int],    :int
  attach_function :lame_get_quant_comp_short,  [:pointer],          :int
  attach_function :lame_set_experimentalX,     [:pointer, :int],    :int
  attach_function :lame_get_experimentalX,     [:pointer],          :int
  attach_function :lame_set_experimentalY,     [:pointer, :int],    :int
  attach_function :lame_get_experimentalY,     [:pointer],          :int
  attach_function :lame_set_experimentalZ,     [:pointer, :int],    :int
  attach_function :lame_get_experimentalZ,     [:pointer],          :int
  attach_function :lame_set_exp_nspsytune,     [:pointer, :int],    :int
  attach_function :lame_get_exp_nspsytune,     [:pointer],          :int
  attach_function :lame_set_msfix,             [:pointer, :double], :void
  attach_function :lame_get_msfix,             [:pointer],          :float

  # VBR
  attach_function :lame_set_VBR,                   [:pointer, :vbr_mode], :int
  attach_function :lame_get_VBR,                   [:pointer],            :vbr_mode
  attach_function :lame_set_VBR_q,                 [:pointer, :int],      :int
  attach_function :lame_get_VBR_q,                 [:pointer],            :int
  attach_function :lame_set_VBR_quality,           [:pointer, :float],    :int
  attach_function :lame_get_VBR_quality,           [:pointer],            :float
  attach_function :lame_set_VBR_mean_bitrate_kbps, [:pointer, :int],      :int
  attach_function :lame_get_VBR_mean_bitrate_kbps, [:pointer],            :int
  attach_function :lame_set_VBR_min_bitrate_kbps,  [:pointer, :int],      :int
  attach_function :lame_get_VBR_min_bitrate_kbps,  [:pointer],            :int
  attach_function :lame_set_VBR_max_bitrate_kbps,  [:pointer, :int],      :int
  attach_function :lame_get_VBR_max_bitrate_kbps,  [:pointer],            :int
  attach_function :lame_set_VBR_hard_min,          [:pointer, :int],      :int
  attach_function :lame_get_VBR_hard_min,          [:pointer],            :int

  # Filtering control
  attach_function :lame_set_lowpassfreq,   [:pointer, :int], :int
  attach_function :lame_get_lowpassfreq,   [:pointer],       :int
  attach_function :lame_set_lowpasswidth,  [:pointer, :int], :int
  attach_function :lame_get_lowpasswidth,  [:pointer],       :int
  attach_function :lame_set_highpassfreq,  [:pointer, :int], :int
  attach_function :lame_get_highpassfreq,  [:pointer],       :int
  attach_function :lame_set_highpasswidth, [:pointer, :int], :int
  attach_function :lame_get_highpasswidth, [:pointer],       :int

  # psycho acoustics
  attach_function :lame_set_ATHonly,           [:pointer, :int],   :int
  attach_function :lame_get_ATHonly,           [:pointer],         :int
  attach_function :lame_set_ATHshort,          [:pointer, :int],   :int
  attach_function :lame_get_ATHshort,          [:pointer],         :int
  attach_function :lame_set_noATH,             [:pointer, :int],   :int
  attach_function :lame_get_noATH,             [:pointer],         :int
  attach_function :lame_set_ATHtype,           [:pointer, :int],   :int
  attach_function :lame_get_ATHtype,           [:pointer],         :int
  attach_function :lame_set_ATHlower,          [:pointer, :float], :int
  attach_function :lame_get_ATHlower,          [:pointer],         :float
  attach_function :lame_set_athaa_type,        [:pointer, :int],   :int
  attach_function :lame_get_athaa_type,        [:pointer],         :int
  attach_function :lame_set_athaa_sensitivity, [:pointer, :float], :int
  attach_function :lame_get_athaa_sensitivity, [:pointer],         :float

  # blocks
  attach_function :lame_set_allow_diff_short,   [:pointer, :int],   :int
  attach_function :lame_get_allow_diff_short,   [:pointer],         :int
  attach_function :lame_set_useTemporal,        [:pointer, :int],   :int
  attach_function :lame_get_useTemporal,        [:pointer],         :int
  attach_function :lame_set_interChRatio,       [:pointer, :float], :int
  attach_function :lame_get_interChRatio,       [:pointer],         :float
  attach_function :lame_set_no_short_blocks,    [:pointer, :int],   :int
  attach_function :lame_get_no_short_blocks,    [:pointer],         :int
  attach_function :lame_set_force_short_blocks, [:pointer, :int],   :int
  attach_function :lame_get_force_short_blocks, [:pointer],         :int
  attach_function :lame_set_emphasis,           [:pointer, :int],   :int
  attach_function :lame_get_emphasis,           [:pointer],         :int

  # TEST from here
  # internal variables
  attach_function :lame_get_version,              [:pointer], :int
  attach_function :lame_get_encoder_delay,        [:pointer], :int
  attach_function :lame_get_encoder_padding,      [:pointer], :int
  attach_function :lame_get_framesize,            [:pointer], :int
  attach_function :lame_get_mf_samples_to_encode, [:pointer], :int
  attach_function :lame_get_size_mp3buffer,       [:pointer], :int
  attach_function :lame_get_frameNum,             [:pointer], :int
  attach_function :lame_get_totalframes,          [:pointer], :int
  attach_function :lame_get_RadioGain,            [:pointer], :int
  attach_function :lame_get_AudiophileGain,       [:pointer], :int
  attach_function :lame_get_PeakSample,           [:pointer], :float
  attach_function :lame_get_noclipGainChange,     [:pointer], :int
  attach_function :lame_get_noclipScale,          [:pointer], :float

  # initializing parameters
  attach_function :lame_init_params, [:pointer], :int

  # version
  attach_function :get_lame_version,            [], :string
  attach_function :get_lame_short_version,      [], :string
  attach_function :get_lame_very_short_version, [], :string
  attach_function :get_psy_version,             [], :string
  attach_function :get_lame_url,                [], :string
  attach_function :get_lame_os_bitness,         [], :string

  # encoding
  attach_function :lame_encode_buffer,                         [:pointer, :pointer, :pointer, :int, :pointer, :int], :int
  attach_function :lame_encode_buffer_interleaved,             [:pointer, :pointer, :pointer, :int, :pointer, :int], :int
  attach_function :lame_encode_buffer_float,                   [:pointer, :pointer, :pointer, :int, :pointer, :int], :int
  attach_function :lame_encode_buffer_ieee_float,              [:pointer, :pointer, :pointer, :int, :pointer, :int], :int
  attach_function :lame_encode_buffer_interleaved_ieee_float,  [:pointer, :pointer, :int, :pointer, :int],           :int
  attach_function :lame_encode_buffer_ieee_double,             [:pointer, :pointer, :pointer, :int, :pointer, :int], :int
  attach_function :lame_encode_buffer_interleaved_ieee_double, [:pointer, :pointer, :int, :pointer, :int],           :int
  attach_function :lame_encode_buffer_long,                    [:pointer, :pointer, :pointer, :int, :pointer, :int], :int
  attach_function :lame_encode_buffer_long2,                   [:pointer, :pointer, :pointer, :int, :pointer, :int], :int
  attach_function :lame_encode_buffer_int,                     [:pointer, :pointer, :pointer, :int, :pointer, :int], :int

  # flushing
  attach_function :lame_encode_flush,       [:pointer, :pointer, :int], :int
  attach_function :lame_encode_flush_nogap, [:pointer, :pointer, :int], :int

  # closing
  attach_function :lame_close,              [:pointer], :int

end
