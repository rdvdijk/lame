module LAME
  module Encoding
    class Id3
      extend Forwardable

      attr_reader :configuration

      def_delegators :configuration, :global_flags, :framesize, :output_buffer_size

      def initialize(configuration)
        @configuration = configuration
      end

      def v1
        tag_size = v1_tag_size
        output = output_buffer(tag_size)
        LAME.lame_get_id3v1_tag(global_flags, output, tag_size)
        output.get_bytes(0, tag_size)
      end

      def v2
        tag_size = v2_tag_size
        output = output_buffer(tag_size)
        LAME.lame_get_id3v2_tag(global_flags, output, tag_size)
        output.get_bytes(0, tag_size)
      end

      private

      def output_buffer(size)
        Buffer.create_empty(:uchar, size)
      end

      # LAME returns the required buffer size if the input buffer is too small.
      def v1_tag_size
        small_buffer = output_buffer(0)
        LAME.lame_get_id3v1_tag(global_flags, small_buffer, 0)
      end

      # LAME returns the required buffer size if the input buffer is too small.
      def v2_tag_size
        small_buffer = output_buffer(0)
        LAME.lame_get_id3v2_tag(global_flags, small_buffer, 0)
      end

    end
  end
end
