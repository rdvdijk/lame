module LAME
  module FFI

    # We need a ManagedStruct to clean up after LAME.
    class GlobalFlags < ::FFI::ManagedStruct
      layout :class_id, :uint

      def initialize
        lame_struct = LAME.lame_init
        super(lame_struct)
      end

      def self.release(ptr)
        LAME.lame_close(ptr)
      end
    end

  end
end

