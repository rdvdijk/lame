module LAME
  module Encoding
    class Flusher
      extend Forwardable

      attr_reader :configuration

      def_delegators :configuration, :global_flags, :framesize, :output_buffer_size

      def initialize(configuration)
        @configuration = configuration
      end

      def flush
        output = Buffer.create_empty(:uchar, output_buffer_size)

        mp3_size = LAME.lame_encode_flush(global_flags, output, output_buffer_size)

        output.get_bytes(0, mp3_size)
      end

    end
  end
end
