module LAME
  class Id3
    extend Forwardable

    def_delegators :@configuration, :global_flags, :framesize, :output_buffer_size

    def initialize(configuration)
      @configuration = configuration
    end

    def v1
      output = output_buffer

      tag_size = LAME.lame_get_id3v1_tag(global_flags, output, output_buffer_size)

      output.get_bytes(0, tag_size)
    end

    def v2
      output = output_buffer

      tag_size = LAME.lame_get_id3v2_tag(global_flags, output, output_buffer_size)

      output.get_bytes(0, tag_size)
    end

    private

    # TODO:
    # this buffer could not be large enough.. check the return code of the 
    # lame_get_id3vX_tag calls and create larger buffer if needed
    def output_buffer
      Buffer.create_empty(:uchar, output_buffer_size)
    end

  end
end
