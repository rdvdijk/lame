module LAME
  module FFI

    # We need a ManagedStruct to clean up after LAME.
    class DecodeFlags < ::FFI::ManagedStruct
      layout :head, :uchar # Not actually used, but FFI needs a layout..

      def initialize
        hip_struct = LAME.hip_decode_init
        super(hip_struct)
      end

      def self.release(ptr)
        LAME.hip_decode_exit(ptr)
      end
    end

  end
end
