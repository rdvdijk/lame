module LAME
  module Encoding
    class EncodeShortBuffer
      extend Forwardable

      def_delegators :@configuration, :global_flags, :framesize, :output_buffer_size

      def initialize(configuration)
        @configuration = configuration
      end

      def encode_frame(left, right)
        left_buffer  = Buffer.create(:short, left)
        right_buffer = Buffer.create(:short, right)
        output       = Buffer.create_empty(:uchar, output_buffer_size)

        mp3_size = LAME.lame_encode_buffer(global_flags,
                                           left_buffer, right_buffer, left.size,
                                           output, output_buffer_size)

        output.get_bytes(0, mp3_size)
      end

    end
  end
end
