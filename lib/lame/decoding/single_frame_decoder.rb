module LAME
  module Decoding
    class SingleFrameDecoder

      def initialize(decode_flags, mp3_data)
        @decode_flags = decode_flags
        @mp3_data = mp3_data
      end

      def decode(data)
        flush_buffer do |decoded_frame|
          yield decoded_frame
        end
        decode_data(data) do |decoded_frame|
          yield decoded_frame
        end
      end

      private

      def flush_buffer(&block)
        in_buffer = LAME::Buffer.create_empty(:uchar, 0)
        decode_buffer(in_buffer, &block)
      end

      def decode_data(data, &block)
        in_buffer = LAME::Buffer.create_uchar(data)
        decode_buffer(in_buffer, &block)
      end

      def decode_buffer(in_buffer, &block)
        out_left, out_right = output_buffers
        result = LAME.hip_decode1_headers(@decode_flags, in_buffer, in_buffer.size, out_left, out_right, @mp3_data)

        if result > 0
          yield buffers_to_zipped_array(out_left, out_right)
          flush_buffer(&block)
        end
        raise DecodingError if result < 0
      end

      def output_buffers
        out_left  = LAME::Buffer.create_empty(:short, 1152)
        out_right = LAME::Buffer.create_empty(:short, 1152)
        [out_left, out_right]
      end

      def buffers_to_zipped_array(left_buffer, right_buffer)
        left = left_buffer.read_array_of_short(left_buffer.size/2)
        right = right_buffer.read_array_of_short(right_buffer.size/2)

        left.zip(right)
      end

    end
  end
end
