require "ffi"

require "lame/version"

module LAME

  extend FFI::Library
  #ffi_lib "libmp3lame"
  ffi_lib "/Users/roel/code/personal/lame/lame-3.99.5/libmp3lame/.libs/libmp3lame.0.dylib"

  # These `attach_function` declarations are in the order of lame.h:

  # initialization
  attach_function :lame_init, [], :pointer

  # global flags
  attach_function :lame_set_num_samples,        [:pointer, :ulong], :int
  attach_function :lame_get_num_samples,        [:pointer],         :ulong
  attach_function :lame_set_in_samplerate,      [:pointer, :int],   :int
  attach_function :lame_get_in_samplerate,      [:pointer],         :int
  attach_function :lame_set_num_channels,       [:pointer, :int],   :int
  attach_function :lame_get_num_channels,       [:pointer],         :int
  attach_function :lame_set_scale,              [:pointer, :float], :int
  attach_function :lame_get_scale,              [:pointer],         :float
  attach_function :lame_set_scale_left,         [:pointer, :float], :int
  attach_function :lame_get_scale_left,         [:pointer],         :float
  attach_function :lame_set_scale_right,        [:pointer, :float], :int
  attach_function :lame_get_scale_right,        [:pointer],         :float
  attach_function :lame_set_out_samplerate,     [:pointer, :int],   :int
  attach_function :lame_get_out_samplerate,     [:pointer],         :int
  attach_function :lame_set_analysis,           [:pointer, :int],   :int
  attach_function :lame_get_analysis,           [:pointer],         :int
  attach_function :lame_set_bWriteVbrTag,       [:pointer, :int],   :int
  attach_function :lame_get_bWriteVbrTag,       [:pointer],         :int
  attach_function :lame_set_decode_only,        [:pointer, :int],   :int
  attach_function :lame_get_decode_only,        [:pointer],         :int
  attach_function :lame_set_quality,            [:pointer, :int],   :int
  attach_function :lame_get_quality,            [:pointer],         :int
  attach_function :lame_set_mode,               [:pointer, :int],   :int
  attach_function :lame_get_mode,               [:pointer],         :int
  attach_function :lame_set_force_ms,           [:pointer, :int],   :int
  attach_function :lame_get_force_ms,           [:pointer],         :int
  attach_function :lame_set_free_format,        [:pointer, :int],   :int
  attach_function :lame_get_free_format,        [:pointer],         :int
  attach_function :lame_set_findReplayGain,     [:pointer, :int],   :int
  attach_function :lame_get_findReplayGain,     [:pointer],         :int
  attach_function :lame_set_decode_on_the_fly,  [:pointer, :int],   :int
  attach_function :lame_get_decode_on_the_fly,  [:pointer],         :int
  attach_function :lame_set_nogap_total,        [:pointer, :int],   :int
  attach_function :lame_get_nogap_total,        [:pointer],         :int
  attach_function :lame_set_nogap_currentindex, [:pointer, :int],   :int
  attach_function :lame_get_nogap_currentindex, [:pointer],         :int
  # TODO: Callbacks
  # attach_function :lame_set_errorf,             [:pointer, :pointer],   :int
  # attach_function :lame_set_debugf,             [:pointer, :pointer],   :int
  # attach_function :lame_set_msgf,               [:pointer, :pointer],   :int
  attach_function :lame_set_brate,              [:pointer, :int],   :int
  attach_function :lame_get_brate,              [:pointer],         :int
  attach_function :lame_set_compression_ratio,  [:pointer, :int],   :int
  attach_function :lame_get_compression_ratio,  [:pointer],         :int
  attach_function :lame_set_preset,             [:pointer, :int],   :int
  attach_function :lame_set_asm_optimizations,  [:pointer, :int, :int], :int

  attach_function :lame_get_framesize,        [:pointer],         :int

  # initializing parameters
  attach_function :lame_init_params, [:pointer], :int

  # encoding
  attach_function :lame_encode_buffer,      [:pointer, :pointer, :pointer, :int, :pointer, :int], :int
  # UNTESTED!
  attach_function :lame_encode_buffer_int,  [:pointer, :pointer, :pointer, :int, :pointer, :int], :int

  # flushing
  attach_function :lame_encode_flush,       [:pointer, :pointer, :int], :int
  attach_function :lame_encode_flush_nogap, [:pointer, :pointer, :int], :int

  # closing
  attach_function :lame_close,              [:pointer], :int

end
