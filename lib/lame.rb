require "ffi"
require "lame/version"
require "lame/ffi"
require "lame/error"
require "lame/delegation"
require "lame/configuration"
require "lame/buffer"

require "lame/encoding/encode_short_buffer"
require "lame/encoding/flusher"
require "lame/encoding/id3"
require "lame/encoding/vbr_info"
require "lame/encoder"

require "lame/decoding/mpeg_audio_frame_matcher"
require "lame/decoder"

module LAME

  extend ::FFI::Library
  ffi_lib "libmp3lame"

  include FFI

end
