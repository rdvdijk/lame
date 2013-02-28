module LAME
  class Decoder

    attr_reader :decode_flags, :mp3_file_path

    def initialize(mp3_file_path)
      @decode_flags = FFI::DecodeFlags.new
      @mp3_file_path = mp3_file_path
    end

  end
end
