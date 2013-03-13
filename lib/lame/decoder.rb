module LAME
  class Decoder

    attr_reader :decode_flags, :mp3_file, :mp3_data

    def initialize(mp3_file)
      @decode_flags = FFI::DecodeFlags.new
      @mp3_file = mp3_file

      skip_id3_tag
      @mp3_data = parse_mp3_data
    end

    def each_frame
      stream_decoder.each_frame do |frame|
        yield frame
      end
    end

    private

    def stream_decoder
      @stream_decoder ||= Decoding::StreamDecoder.new(mp3_file, mp3_data)
    end

    def skip_id3_tag
      Decoding::Id3TagParser.new(mp3_file).skip!
    end

    def parse_mp3_data
      Decoding::Mp3DataHeaderParser.new(@decode_flags, mp3_file).parse!
    end

  end
end
