module LAME
  module Encoding
    class InterleavedShortBufferEncoder < InterleavedBufferEncoder

      def data_type
        :short
      end

      def lame_function
        :lame_encode_buffer_interleaved
      end

    end
  end
end
