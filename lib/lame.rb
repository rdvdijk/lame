require "ffi"
require "lame/version"
require "lame/ffi"
require "lame/error"
require "lame/delegation"
require "lame/configuration"
require "lame/buffer"
require "lame/encoders/short"
require "lame/encoder"

module LAME

  extend ::FFI::Library
  ffi_lib "libmp3lame"

  include FFI

end
