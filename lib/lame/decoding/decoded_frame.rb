module LAME
  module Decoding
    class DecodedFrame

      attr_reader :left, :right

      def initialize(left, right)
        @left = left
        @right = right
      end

      def self.from_short_buffers(left_buffer, right_buffer)
        left  = left_buffer.read_array_of_short(left_buffer.size/2)
        right = right_buffer.read_array_of_short(right_buffer.size/2)

        new(left, right)
      end

      def samples
        left.zip(right)
      end

    end
  end
end
