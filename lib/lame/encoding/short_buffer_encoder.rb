module LAME
  module Encoding
    class ShortBufferEncoder < StereoBufferEncoder

      def data_type
        :short
      end

      def lame_function
        :lame_encode_buffer
      end

    end
  end
end
