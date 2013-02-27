require 'spec_helper'

describe "Deocding", :slow => true do

  it "decodes a wav file" do
    mp3_file_path = File.expand_path(File.join(File.dirname(__FILE__), '../files/dies-irae-cli-id3v2.mp3'))
    mp3_file = File.open(mp3_file_path, "r")

    # id3
    id3_length = id3_length(mp3_file)
    puts "ID3 length: #{id3_length} bytes"
    mp3_file.read(id3_length)

    # aid TODO (ignored for now)

    # find MP3 sync frame
    # read mp3_data (number of frames etc)

    offset = mpeg_audio_offset(mp3_file)
    puts "offset: #{offset}"

    mpeg_audio_offset(mp3_file, 0, 4096)

  end

  class SyncwordMatcher
    attr_reader :bytes

    def initialize(bytes)
      @bytes = bytes
    end

    def match?
      leading_bits? &&
        mpeg? &&
        layer? &&
        bitrate? &&
        sample_frequency? &&
        abl? &&
        !emphasis?
    end

    # Eleven bits set to '1'
    def leading_bits?
      (bytes[0] & 0b11111111) == 0b11111111 &&
        (bytes[1] & 0b11100000) == 0b11100000
    end

    def mpeg?
      (bytes[1] & 0x11000) != 0x01000
    end

    # Second byte:
    # - 0b010 (Layer 3)
    # - 0b100 (Layer 2)
    # - 0b110 (Layer 1)
    def layer?
      case bytes[2] & 0b110
      when 0b010; true # Layer 3
      when 0b100; true # Layer 2
      when 0b110; true # Layer 1
      else
        false
      end
    end

    def bitrate?
      # bad bitrate
      return false if (byte & 0b11110000) == 0x11110000
    end

    def sample_frequency?
      # no sample frequency with (32,44.1,48)/(1,2,4)
      return false if (byte & 0b1100) == 0b110
    end

    def abl?
    end

    def emphasis?
    end

  end

  # if (
  #   (p[1] & 0x18) == 0x18 && 
  #   (p[1] & 0x06) == 0x04 && 
  #   abl2[p[2] >> 4] & (1 << (p[3] >> 6))
  # )

  # abl2 = [ 0, 7, 7, 7, 0, 7, 0, 0, 
  #          0, 0, 0, 8, 8, 8, 8, 8 ]

  def mpeg_audio_offset(mp3_file, offset = 0, window_size = 4)
    mp3_file.seek(offset)

    decode_flags = LAME::FFI::DecodeFlags.new
    begin
      in_data = mp3_file.read(window_size)

      in_buffer = LAME::Buffer.create_uchar(in_data)

      out_left = LAME::Buffer.create_empty(:short, 1152)
      out_right = LAME::Buffer.create_empty(:short, 1152)

      mp3_data = LAME::FFI::MP3Data.new

      enc_delay = ::FFI::MemoryPointer.new(:int, 1)
      enc_padding = ::FFI::MemoryPointer.new(:int, 1)

      result = LAME.hip_decode1_headersB(decode_flags, in_buffer, window_size, out_left, out_right, mp3_data, enc_delay, enc_padding)

      if result > 0
        puts "-"*25
        puts "read data at offset: #{offset}"

        puts "stereo:      #{mp3_data[:stereo]}"
        puts "samplerate:  #{mp3_data[:samplerate]}"
        puts "bitrate:     #{mp3_data[:bitrate]}"
        puts "mode:        #{mp3_data[:mode]}"
        puts "mod_ext:     #{mp3_data[:mod_ext]}"
        puts "framesize:   #{mp3_data[:framesize]}"
        puts "nsamp:       #{mp3_data[:nsamp]}"
        puts "totalframes: #{mp3_data[:totalframes]}"
        puts "framenum:    #{mp3_data[:framenum]}"
        puts "enc_delay:   #{enc_delay.read_array_of_int(1)}"
        puts "enc_padding: #{enc_padding.read_array_of_int(1)}"
        puts "result:      #{result}"
      end

      #return offset if result > 0

      offset += 1
      mp3_file.seek(offset)
    end while in_data.length == window_size
  end

  # http://id3.org/id3v2.4.0-structure
  # 10 bytes header:
  # - "ID3"
  # - "xx" version (2 bytes)
  # - "x" flags (1 byte)
  # - "xxxx" size (4 bytes)
  def id3_length(file)
    header = file.read(10)
    if id3?(header)
      size = header[-4..-1]

      b0 = size[0].ord
      b1 = size[1].ord
      b2 = size[2].ord
      b3 = size[3].ord

      # rubify this sometime:
      (((((b0 << 7) + b1) << 7) + b2) << 7) + b3
    end
  end

  def id3?(header)
    header.start_with?("ID3")
  end

end
