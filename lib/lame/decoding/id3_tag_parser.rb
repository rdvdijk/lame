module LAME
  module Decoding

    # http://id3.org/id3v2.4.0-structure
    # Section 3.1. ID3v2 header
    #
    # 10 bytes header:
    # - "ID3"
    # - "xx" version (2 bytes)
    # - "x" flags (1 byte)
    # - "xxxx" size (4 bytes)
    class Id3TagParser

      HEADER_SIZE = 10

      def initialize(file)
        @file = file
      end

      def skip!
        @file.seek(0)
        @file.seek(id3_length)
      end

      private

      def id3_length
        header = @file.read(HEADER_SIZE)

        if id3?(header)
          HEADER_SIZE + parse_id3_tag_length(header[-4..-1])
        else
          0
        end
      end

      def parse_id3_tag_length(size_bits)
        b0 = size_bits[0].ord
        b1 = size_bits[1].ord
        b2 = size_bits[2].ord
        b3 = size_bits[3].ord

        # rubify this sometime:
        (((((b0 << 7) + b1) << 7) + b2) << 7) + b3
      end

      def id3?(header)
        header.start_with?("ID3")
      end

    end
  end
end
