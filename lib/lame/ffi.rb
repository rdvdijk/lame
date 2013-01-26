require 'lame/ffi/global_flags'
require 'lame/ffi/enums'
require 'lame/ffi/version'
require 'lame/ffi/functions'

module LAME
  module FFI

    def self.included(base)
      base.class_eval do
        include Enums
        include Functions
      end
    end

  end
end
