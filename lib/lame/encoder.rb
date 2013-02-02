module LAME
  class Encoder

    attr_reader :global_flags

    def initialize
      @global_flags = FFI::GlobalFlags.new
    end

    def configure
      yield configuration
      apply_configuration
    end

    def encode_short(left, right)
      apply_configuration

      mp3_data = Encoders::Short.new(configuration).encode_frame(left, right)
      yield mp3_data

      # TODO:
      # each_frame(left, right, framesize) do |left_frame, right_frame|
      #   mp3data = Encoders::Short.new(framesize).encode_frame(left_frame, right_frame)
      #   yield mp3data
      # end
    end

    def flush
      mp3_data = Flusher.new(configuration).flush

      if block_given?
        yield mp3_data
      else
        mp3_data
      end
    end

    def vbr_frame
      mp3_data = VBRInfo.new(configuration).frame

      if block_given?
        yield mp3_data
      else
        mp3_data
      end
    end

    def configuration
      @configuration ||= Configuration.new(global_flags)
    end

    def framesize
      configuration.framesize
    end

    private

    def apply_configuration
      configuration.apply! unless configuration.applied?
    end

  end
end
