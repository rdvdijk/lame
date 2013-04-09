module LAME
  class Decoder
    extend Forwardable

    attr_reader :decode_flags, :mp3_file, :mp3_data

    def_delegators :mp3_data, :channel_mode, :sample_rate

    def initialize(mp3_file)
      @decode_flags = FFI::DecodeFlags.new
      @mp3_file = mp3_file

      skip_id3_tag
      @mp3_data = parse_mp3_data
    end

    def each_decoded_frame
      stream_decoder.each_decoded_frame do |decoded_frame|
        yield decoded_frame
      end
    end

    private

    def stream_decoder
      @stream_decoder ||= Decoding::StreamDecoder.new(decode_flags, mp3_data, mp3_file)
    end

    def skip_id3_tag
      Decoding::Id3TagParser.new(mp3_file).skip!
    end

    def parse_mp3_data
      Decoding::Mp3DataHeaderParser.new(decode_flags, mp3_file).parse!
    end

  end
end
