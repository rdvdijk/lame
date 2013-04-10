module LAME
  class FileEncoder < Encoder

    def initialize
      super
      @id3v2_size = 0
    end

    def encode(input_file, output_file)
      @wav_file = input_file

      File.open(output_file, "wb") do |mp3_file|
        @mp3_file = mp3_file

        write_id3v2_tag if id3v2?
        write_mp3_frames
        flush_mp3_frame
        write_id3v1_tag if id3v1?
        write_vbr_frame if vbr?
      end
    end

    private

    def write_id3v1_tag
      id3v1 do |tag|
        @mp3_file.write tag
      end
    end

    def write_id3v2_tag
      id3v2 do |tag|
        @mp3_file.write tag
        @id3v2_size = tag.size
      end
    end

    def write_mp3_frames
      wav_reader.each_buffer(framesize) do |read_buffer|
        left  = read_buffer.samples.map { |s| s[0] }
        right = read_buffer.samples.map { |s| s[1] }

        encode_short(left, right) do |mp3|
          @mp3_file.write mp3
        end
      end
    end

    def flush_mp3_frame
      flush do |flush_frame|
        @mp3_file.write(flush_frame)
      end
    end

    def write_vbr_frame
      vbr_frame do |vbr_frame|
        @mp3_file.seek(@id3v2_size)
        @mp3_file.write(vbr_frame)
      end
    end

    def id3v1?
      return true
      configuration.id3v1?
    end

    def id3v2?
      return true
      configuration.id3v2?
    end

    def vbr?
      return true
      configuration.vbr?
    end

    def wav_reader
      WaveFile::Reader.new(@wav_file)
    end

  end
end
