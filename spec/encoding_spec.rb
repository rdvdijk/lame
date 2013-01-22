require 'spec_helper'
require 'wavefile'
require 'pry'

describe "Encoding" do

  it "encodes a wav file" do
    wav_path = File.expand_path(File.join(File.dirname(__FILE__), 'files/example2.wav'))
    mp3_path = File.expand_path(File.join(File.dirname(__FILE__), 'files/example2.mp3'))
    reader = WaveFile::Reader.new(wav_path)

    # setup
    flags_pointer = LAME.lame_init
    LAME.lame_init_params(flags_pointer)

    # number of samples to read
    framesize = LAME.lame_get_framesize(flags_pointer)

    left_buffer  = FFI::MemoryPointer.new(:short, framesize)
    right_buffer = FFI::MemoryPointer.new(:short, framesize)

    File.open(mp3_path, "wb") do |file|
      reader.each_buffer(framesize) do |read_buffer|

        # read samples (ranges from -32k to +32k)
        read_buffer.samples.each.with_index do |(left, right), index|
          left_buffer.put_short(index, left)
          right_buffer.put_short(index, right)
        end
        input_buffer_size = read_buffer.samples.size

        puts "read #{input_buffer_size} wav samples"

        # encode
        buffer_size = (128*1024)+16384
        buffer = FFI::MemoryPointer.new(:uchar, buffer_size)

        size = LAME.lame_encode_buffer(
          flags_pointer,
          left_buffer, right_buffer, input_buffer_size,
          buffer, buffer_size
        )

        puts "encoded #{size} mp3 bytes"

        # write to file
        (0..size).each do |i|
          file.print buffer.get_uchar(i).chr
        end
      end

      # wrap up
      buffer_size = (128*1024)+16384
      buffer = FFI::MemoryPointer.new(:uchar, buffer_size)

      size = LAME.lame_encode_flush(flags_pointer, buffer, buffer_size)
      file.write (0..size).map { |i| buffer.get_uchar(i) }.pack("C*")
    end

    # close
    LAME.lame_close(flags_pointer).should eql 0
  end

end
