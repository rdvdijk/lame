module LAME
  module Decoding
    class StreamDecoder

      # arbitrary, taken from get_audio.c#lame_decode_fromfile
      DECODE_SIZE = 1024

      def initialize(decode_flags, mp3_data, stream)
        @stream = stream
        @single_frame_decoder = SingleFrameDecoder.new(decode_flags, mp3_data)
      end

      def each_frame(&block)
        begin
          @data = @stream.read(DECODE_SIZE)

          decode &block
        end until end_of_stream?
      end

      private

      def decode
        return if end_of_stream?

        @single_frame_decoder.decode(@data) do |frame|
          yield frame
        end
      end

      def end_of_stream?
        !@data
      end

    end
  end
end
