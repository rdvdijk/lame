require 'spec_helper'
require 'wavefile'
# require 'digest'

describe "Encoding", :slow => true do

  let(:wav_file) { WaveFileGenerator.new(:length => 2).generate }
  let(:wav_path) { wav_file.path }
  let(:mp3_path_raw) { Tempfile.new("output-raw.mp3") }
  let(:mp3_path_api) { Tempfile.new("output-api.mp3") }

  let(:wav_reader) { WaveFile::Reader.new(wav_path) }

  it "encodes a file by api" do

    encoder = LAME::Encoder.new

    encoder.configure do |config|
      config.id3.write_automatic = false
      config.id3.v2 = true
      config.id3.title = "Dies Irae"
      config.id3.genre = "Classical"

      #config.bitrate = 192

      # config.preset = :V0 # doesn't work?
      config.vbr.mode = :vbr_default
      config.vbr.q = 0
    end

    File.open(mp3_path_api, "wb") do |file|

      id3v2_size = 0
      encoder.id3v2 do |tag|
        file.write tag
        id3v2_size = tag.size
      end

      wav_reader.each_buffer(encoder.framesize) do |read_buffer|
        left  = read_buffer.samples.map { |s| s[0] }
        right = read_buffer.samples.map { |s| s[1] }

        encoder.encode_short(left, right) do |mp3|
          file.write mp3
        end
      end
      encoder.flush do |flush_frame|
        file.write(flush_frame)
      end

      encoder.id3v1 do |tag|
        file.write tag
      end

      encoder.vbr_frame do |vbr_frame|
        file.seek(id3v2_size)
        file.write(vbr_frame)
      end

    end

    # TODO: Need a better way to test output..
    # Digest::MD5.hexdigest(File.read(mp3_path_api)).should eql "d1cd92c106e7aac4f5291fd141a19e10"
  end

  # This test serves as an example how to use the LAME API
  it "encodes a wav file" do

   # setup
    flags_pointer = LAME.lame_init
    LAME.lame_init_params(flags_pointer)

    # LAME.id3tag_init(flags_pointer) # needed?
    # LAME.id3tag_set_title(flags_pointer, "foo")

    # number of samples to read
    framesize = LAME.lame_get_framesize(flags_pointer)

    # input buffers
    left_buffer  = ::FFI::MemoryPointer.new(:short, framesize)
    right_buffer = ::FFI::MemoryPointer.new(:short, framesize)

    # output buffer
    buffer_size = (128*1024)+16384
    buffer = ::FFI::MemoryPointer.new(:uchar, buffer_size)

    File.open(mp3_path_raw, "wb") do |file|
      wav_reader.each_buffer(framesize) do |read_buffer|

        # read samples (ranges from -32k to +32k)
        read_buffer.samples.each.with_index do |(left, right), index|
          byte_offset = index * 2
          left_buffer.put_short(byte_offset, left)
          right_buffer.put_short(byte_offset, right)
        end

        input_buffer_size = read_buffer.samples.size

        # encode to mp3 frame
        size = LAME.lame_encode_buffer(
          flags_pointer,
          left_buffer, right_buffer, input_buffer_size,
          buffer, buffer_size
        )

        # write to file
        file.write buffer.get_bytes(0, size)
      end

      # flush final frame
      size = LAME.lame_encode_flush(flags_pointer, buffer, buffer_size)
      file.write buffer.get_bytes(0, size)

      # write "lametag" frame with extra info
      size = LAME.lame_get_lametag_frame(flags_pointer, buffer, buffer_size)
      file.seek(0)
      file.write buffer.get_bytes(0, size)
    end

    # close
    LAME.lame_close(flags_pointer)

    # TODO: Need a better way to test output..
    # Digest::MD5.hexdigest(File.read(mp3_path_raw)).should eql "84a1ce7994bb4a54fc13fb5381ebac40"
  end

end
