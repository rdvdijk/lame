module LAME
  class Encoder

    BUFFER_ENCODERS = {
      :short => Encoding::ShortBufferEncoder,
      :float => Encoding::FloatBufferEncoder,
      :long  => Encoding::LongBufferEncoder,
      :short_interleaved => Encoding::InterleavedShortBufferEncoder,
      :float_interleaved => Encoding::InterleavedFloatBufferEncoder
    }

    attr_reader :global_flags

    def initialize
      @global_flags = FFI::GlobalFlags.new
    end

    def configure
      yield configuration
      apply_configuration
    end

    def encode_short(left, right, &block)
      encode_stereo(left, right, :short, &block)
    end

    def encode_float(left, right, &block)
      encode_stereo(left, right, :float, &block)
    end

    def encode_long(left, right, &block)
      encode_stereo(left, right, :long, &block)
    end

    def encode_interleaved_short(samples, &block)
      encode_interleaved(samples, :short_interleaved, &block)
    end

    def encode_interleaved_float(samples, &block)
      encode_interleaved(samples, :float_interleaved, &block)
    end

    def flush(&block)
      mp3_data = Encoding::Flusher.new(configuration).flush
      yield_or_return(mp3_data, &block)
    end

    def vbr_frame(&block)
      mp3_data = Encoding::VBRInfo.new(configuration).frame
      yield_or_return(mp3_data, &block)
    end

    def id3v1(&block)
      mp3_data = Encoding::Id3.new(configuration).v1
      yield_or_return(mp3_data, &block)
    end

    def id3v2(&block)
      mp3_data = Encoding::Id3.new(configuration).v2
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

    def encode_stereo(left, right, data_type)
      apply_configuration

      each_frame(left, right) do |left_frame, right_frame|
        encoder = BUFFER_ENCODERS[data_type].new(configuration)
        mp3_data = encoder.encode_frame(left_frame, right_frame)
        yield mp3_data
      end
    end

    def encode_interleaved(interleaved_samples, data_type)
      apply_configuration

      each_interleaved_frame(interleaved_samples) do |interleaved_frame|
        encoder = BUFFER_ENCODERS[data_type].new(configuration)
        mp3_data = encoder.encode_frame(interleaved_frame)
        yield mp3_data
      end
    end

    def each_frame(left, right)
      left.zip(right).each_slice(framesize) do |slice|
        yield slice.transpose
      end
    end

    def each_interleaved_frame(interleaved_samples)
      interleaved_samples.each_slice(framesize * 2) do |slice|
        yield slice
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
