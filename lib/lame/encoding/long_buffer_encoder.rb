module LAME
  module Encoding
    class LongBufferEncoder < StereoBufferEncoder

      def data_type
        :long
      end

      def lame_function
        :lame_encode_buffer_long2
      end

    end
  end
end
