require "ffi"
require "forwardable"
require "lame/version"
require "lame/ffi"
require "lame/error"
require "lame/delegation"
require "lame/configuration"
require "lame/buffer"

require "lame/encoding/stereo_buffer_encoder"
require "lame/encoding/short_buffer_encoder"
require "lame/encoding/float_buffer_encoder"
require "lame/encoding/long_buffer_encoder"
require "lame/encoding/interleaved_buffer_encoder"
require "lame/encoding/interleaved_short_buffer_encoder"
require "lame/encoding/interleaved_float_buffer_encoder"
require "lame/encoding/flusher"
require "lame/encoding/id3"
require "lame/encoding/vbr_info"
require "lame/encoder"

require "lame/decoding/id3_tag_parser"
require "lame/decoding/mp3_data_header_parser"
require "lame/decoding/mpeg_audio_frame_matcher"
require "lame/decoding/mpeg_audio_frame_finder"
require "lame/decoding/single_frame_decoder"
require "lame/decoding/stream_decoder"
require "lame/decoding/decoded_frame"
require "lame/decoder"

module LAME

  extend ::FFI::Library
  ffi_lib "libmp3lame"

  include FFI

end
