module LAME
  module Encoding
    class StereoBufferEncoder
      extend Forwardable

      attr_reader :configuration

      def_delegators :configuration, :global_flags, :framesize, :output_buffer_size

      def initialize(configuration)
        @configuration = configuration
      end

      def encode_frame(left, right)
        left_buffer  = Buffer.create(data_type, left)
        right_buffer = Buffer.create(data_type, right)

        output       = Buffer.create_empty(:uchar, output_buffer_size)

        mp3_size = LAME.send(lame_function, global_flags,
                                            left_buffer, right_buffer, left.size,
                                            output, output_buffer_size)

        output.get_bytes(0, mp3_size)
      end

    end
  end
end
