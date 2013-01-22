require "ffi"

require "lame/version"

module LAME

  extend FFI::Library
  #ffi_lib "libmp3lame"
  ffi_lib "/Users/roel/code/personal/lame/lame-3.99.5/libmp3lame/.libs/libmp3lame.0.dylib"

  # These `attach_function` declarations are in the order of lame.h:

  # initialization
  attach_function :lame_init,               [],               :pointer

  # global flags
  attach_function :lame_get_num_channels,   [:pointer],       :int
  attach_function :lame_set_num_channels,   [:pointer, :int], :int
  attach_function :lame_get_framesize,      [:pointer],       :int

  # initializing parameters
  attach_function :lame_init_params,        [:pointer], :int

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
