module LAME
  module Encoding
    class InterleavedFloatBufferEncoder < InterleavedBufferEncoder

      def data_type
        :float
      end

      def lame_function
        :lame_encode_buffer_interleaved_ieee_float
      end

    end
  end
end
