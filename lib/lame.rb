require "ffi"
require "lame/version"
require "lame/ffi"
require "lame/delegation"
require "lame/configuration"
require "lame/encoder"

module LAME

  extend ::FFI::Library
  ffi_lib "libmp3lame"

  include FFI

end
