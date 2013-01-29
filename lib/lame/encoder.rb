module LAME
  class Encoder

    attr_reader :global_flags, :configuration

    def initialize
      @global_flags = FFI::GlobalFlags.new
    end

    def configure
      @configuration = Configuration.new(@global_flags)
      yield @configuration
    end

  end
end
