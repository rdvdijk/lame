module LAME
  module Encoders
    class Short

      def initialize(configuration)
        @configuration = configuration
      end

      def encode_frame(left, right)
        left_buffer  = Buffer.create(:short, left)
        right_buffer = Buffer.create(:short, right)
        output       = Buffer.create_empty(:uchar, output_size)

        mp3_size = LAME.lame_encode_buffer(global_flags,
                                           left_buffer, right_buffer, framesize,
                                           output, output_size)

        output.get_bytes(0, mp3_size)
      end

      def output_size
        ((framesize * 1.25) + 7200).ceil
      end

      def framesize
        @configuration.framesize
      end

      def global_flags
        @configuration.global_flags
      end

    end
  end
end
