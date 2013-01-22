require 'spec_helper'
require 'wavefile'

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

    # input buffers
    left_buffer  = FFI::MemoryPointer.new(:short, framesize)
    right_buffer = FFI::MemoryPointer.new(:short, framesize)

    # output buffer
    buffer_size = (128*1024)+16384
    buffer = FFI::MemoryPointer.new(:uchar, buffer_size)

    File.open(mp3_path, "wb") do |file|
      reader.each_buffer(framesize) do |read_buffer|

        # read samples (ranges from -32k to +32k)
        read_buffer.samples.each.with_index do |(left, right), index|
          byte_offset = index * 2
          left_buffer.put_short(byte_offset, left)
          right_buffer.put_short(byte_offset, right)
        end
        input_buffer_size = read_buffer.samples.size

        # encode to mp3
        size = LAME.lame_encode_buffer(
          flags_pointer,
          left_buffer, right_buffer, input_buffer_size,
          buffer, buffer_size
        )

        # write to file
        file.write buffer.get_bytes(0, size)
      end

      # wrap up
      size = LAME.lame_encode_flush(flags_pointer, buffer, buffer_size)
      file.write buffer.get_bytes(0, size)
    end

    # close
    LAME.lame_close(flags_pointer)
  end

end
