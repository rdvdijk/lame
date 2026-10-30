module LAME
  module Encoding
    class InterleavedIntBufferEncoder < InterleavedBufferEncoder

      def data_type
        :int
      end

      def lame_function
        :lame_encode_buffer_interleaved_int
      end

    end
  end
end
