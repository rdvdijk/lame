require 'spec_helper'
require 'wavefile'

describe "Decoding", :slow => true do

  let(:mp3_file_path) { File.expand_path(File.join(File.dirname(__FILE__), '../files/dies-irae-cli-id3v2.mp3')) }
  let(:mp3_file)      { File.open(mp3_file_path, "r") }

  xit "decodes an MP3 file by api" do
    decoder = LAME::Decoder.new(mp3_file)

    format = WaveFile::Format.new(decode.channel_mode, :pcm_16, decoder.sample_rate)

    WaveFile::Writer.new("output1.wav", format) do |writer|

      decoder.each_frame do |frame|
        zipped_buffer = frame.left.zip(frame.right)
        buffer = WaveFile::Buffer.new(zipped_buffer, format)

        writer.write(buffer)
      end

    end
  end

  it "decodes an MP3 file" do
    # id3
    id3_length = id3_length(mp3_file)
    puts "ID3 length: #{id3_length} bytes"
    mp3_file.read(id3_length)

    # aid TODO (ignored for now)

    # find MP3 sync frame

    mp3_offset = mpeg_audio_offset(mp3_file, id3_length)
    puts "offset: #{mp3_offset}"

    @decode_flags = LAME::FFI::DecodeFlags.new
    @mp3_data = LAME::FFI::MP3Data.new

    # Decode until we have parsed an MP3 header
    mp3_file.seek(mp3_offset)
    begin
      find_header(mp3_file)
    end until @mp3_data.header_parsed?

    # Results:
    if @mp3_data.header_parsed?
      puts "stereo:      #{@mp3_data[:stereo]}"
      puts "samplerate:  #{@mp3_data[:samplerate]}"
      puts "bitrate:     #{@mp3_data[:bitrate]}"
      puts "mode:        #{@mp3_data[:mode]}"
      puts "mod_ext:     #{@mp3_data[:mod_ext]}"
      puts "framesize:   #{@mp3_data[:framesize]}"
      puts "nsamp:       #{@mp3_data[:nsamp]}"
      puts "totalframes: #{@mp3_data[:totalframes]}"
      puts "framenum:    #{@mp3_data[:framenum]}"
    end

    # read mp3_data (number of frames etc)
    format = WaveFile::Format.new(:stereo, :pcm_16, 44100)
    WaveFile::Writer.new("output2.wav", format) do |writer|

      # See get_audio.c:2082 #lame_decode_fromfile
      #
      # Read until we have decode some MP3 data:
      @result = 0
      begin
        @result = decode(mp3_file)

        if @result && @result.any?
          left = @result[0].read_array_of_short(@result[0].size/2)
          right = @result[1].read_array_of_short(@result[1].size/2)
          buffer = WaveFile::Buffer.new(left.zip(right), format)

          writer.write(buffer)
        end
      end until !@result
    end
  end

  def find_header(mp3_file)
    size = 100 # arbitrary, taken from get_audio.c#lame_decode_initfile
    in_data = mp3_file.read(size)

    in_buffer = LAME::Buffer.create_uchar(in_data)
    out_left  = LAME::Buffer.create_empty(:short, 0)
    out_right = LAME::Buffer.create_empty(:short, 0)

    enc_delay   = ::FFI::MemoryPointer.new(:int, 1)
    enc_padding = ::FFI::MemoryPointer.new(:int, 1)

    result = LAME.hip_decode1_headersB(@decode_flags, in_buffer, size, out_left, out_right, @mp3_data, enc_delay, enc_padding)

    if @mp3_data.header_parsed?
      puts "header parsed @ #{mp3_file.pos}"
      puts "enc_delay:   #{enc_delay.read_array_of_int(1)}"
      puts "enc_padding: #{enc_padding.read_array_of_int(1)}"
    end
  end

  def decode(mp3_file)
    size = 1024 # arbitrary, taken from get_audio.c#lame_decode_fromfile
    out_left  = LAME::Buffer.create_empty(:short, 1152)
    out_right = LAME::Buffer.create_empty(:short, 1152)

    in_buffer = LAME::Buffer.create_empty(:uchar, 0)

    # see if we have anything left in the internal decode buffer
    result = LAME.hip_decode1_headers(@decode_flags, in_buffer, 0, out_left, out_right, @mp3_data)

    case result
    when -1
      raise "decoding error (a)"
    when 0
      # need more data
    else
      return [out_left, out_right]
    end

    in_data = mp3_file.read(size)
    if !in_data
      return nil
    end

    in_buffer = LAME::Buffer.create_uchar(in_data)

    # else read more data and try again
    result = LAME.hip_decode1_headers(@decode_flags, in_buffer, size, out_left, out_right, @mp3_data)

    case result
    when -1
      raise "decoding error (b)"
    when 0
      # need more data
    else
      return [out_left, out_right]
    end

    []
  end

  def mpeg_audio_offset(mp3_file, offset = 0)
    mp3_file.seek(offset)

    window_size = 4
    begin
      in_data = mp3_file.read(window_size)

      if LAME::MPEGAudioFrameMatcher.new(in_data).match?
        puts "match offset @ #{offset} : #{in_data.bytes.to_a[0].to_s(2)} #{in_data.bytes.to_a[1].to_s(2)} #{in_data.bytes.to_a[2].to_s(2)} #{in_data.bytes.to_a[3].to_s(2)}"
        return offset
      end

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
