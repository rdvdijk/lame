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

      each_frame(left, right) do |left_frame, right_frame|
        mp3_data = Encoders::Short.new(configuration).encode_frame(left_frame, right_frame)
        yield mp3_data
      end
    end

    def flush(&block)
      mp3_data = Flusher.new(configuration).flush
      yield_or_return(mp3_data, &block)
    end

    def vbr_frame(&block)
      mp3_data = VBRInfo.new(configuration).frame
      yield_or_return(mp3_data, &block)
    end

    def id3v1(&block)
      mp3_data = Id3.new(configuration).v1
      yield_or_return(mp3_data, &block)
    end

    def id3v2(&block)
      mp3_data = Id3.new(configuration).v2
      yield_or_return(mp3_data, &block)
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

    def each_frame(left, right)
      left.zip(right).each_slice(framesize) do |slice|
        yield slice.transpose
      end
    end

    def yield_or_return(value)
      if block_given?
        yield value
      else
        value
      end
    end

  end
end
