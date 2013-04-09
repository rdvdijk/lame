module LAME
  module Encoding
    class FloatBufferEncoder < StereoBufferEncoder

      def data_type
        :float
      end

      def lame_function
        :lame_encode_buffer_ieee_float
      end

    end
  end
end
