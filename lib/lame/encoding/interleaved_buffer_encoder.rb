module LAME
  module Encoding
    class InterleavedBufferEncoder
      extend Forwardable

      attr_reader :configuration

      def_delegators :configuration, :global_flags, :framesize, :output_buffer_size

      def initialize(configuration)
        @configuration = configuration
      end

      def encode_frame(interleaved_samples)
        interleaved_buffer = Buffer.create(data_type, interleaved_samples)
        output             = Buffer.create_empty(:uchar, output_buffer_size)

        mp3_size = LAME.send(lame_function, global_flags,
                                            interleaved_buffer, interleaved_samples.size/2,
                                            output, output_buffer_size)

        output.get_bytes(0, mp3_size)
      end

    end
  end
end
