module LAME
  module Decoding
    class MPEGAudioFrameFinder

      MPEG_HEADER_SIZE = 4

      def initialize(stream)
        @stream = stream
      end

      def find!
        begin
          @data = @stream.read(MPEG_HEADER_SIZE)
          if MPEGAudioFrameMatcher.new(@data).match?
            seek_back!
            return
          end
          seek!
        end until end_of_stream?

        raise MPEGAudioFrameNotFoundError
      end

      private

      def offset
        @stream.pos
      end

      # Move to next 4 bytes.
      def seek!
        @stream.seek(offset - (MPEG_HEADER_SIZE-1))
      end

      # Move back to frame position.
      def seek_back!
        @stream.seek(offset - (MPEG_HEADER_SIZE))
      end

      def end_of_stream?
        !@data || (@data.size != MPEG_HEADER_SIZE)
      end

    end
  end
end
