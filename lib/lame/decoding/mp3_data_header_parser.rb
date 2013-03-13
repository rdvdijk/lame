module LAME
  module Decoding
    class Mp3DataHeaderParser

      SIZE = 100

      # TODO: find mpeg header frame

      def initialize(decode_flags, stream)
        @decode_flags = decode_flags
        @stream = stream
        @mp3_data = LAME::FFI::MP3Data.new
      end

      def parse!
        begin
          @data = @stream.read(SIZE)
          parse_headers
        end until parsed? || end_of_stream?

        if parsed?
          @mp3_data
        else
          raise Mp3DataHeaderNotFoundError
        end
      end

      private

      def parse_headers
        return if !@data

        in_buffer = LAME::Buffer.create_uchar(@data)
        out_left  = LAME::Buffer.create_empty(:short, 0)
        out_right = LAME::Buffer.create_empty(:short, 0)

        enc_delay   = ::FFI::MemoryPointer.new(:int, 1)
        enc_padding = ::FFI::MemoryPointer.new(:int, 1)

        LAME.hip_decode1_headersB(@decode_flags,
                                  in_buffer, @data.length,
                                  out_left, out_right,
                                  @mp3_data,
                                  enc_delay, enc_padding)
      end

      def parsed?
        @mp3_data.header_parsed?
      end

      def end_of_stream?
        !@data
      end

    end
  end
end
