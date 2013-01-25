require 'spec_helper'
require 'wavefile'
require 'mp3info'

describe "ID3 tags" do

  let(:wav_path) { File.expand_path(File.join(File.dirname(__FILE__), '../files/example2.wav')) }
  let(:mp3_path) { File.expand_path(File.join(File.dirname(__FILE__), '../files/example2.mp3')) }

  let(:wav_reader) { WaveFile::Reader.new(wav_path) }

  let(:framesize)    { LAME.lame_get_framesize(@flags_pointer) }
  let(:left_buffer)  { FFI::MemoryPointer.new(:short, framesize) }
  let(:right_buffer) { FFI::MemoryPointer.new(:short, framesize) }

  let(:max_buffer_size) { (128*1024)+16384 }
  let(:buffer) { FFI::MemoryPointer.new(:uchar, max_buffer_size) }

  before do
    @flags_pointer = LAME.lame_init
    LAME.lame_init_params(@flags_pointer)
    LAME.id3tag_init(@flags_pointer) # needed?
  end

  # This test serves as an example how to add id3 tags
  it "adds id3v1 tags" do
    LAME.id3tag_set_title(@flags_pointer, "title")
    LAME.id3tag_set_artist(@flags_pointer, "artist")
    LAME.id3tag_set_album(@flags_pointer, "album")
    LAME.id3tag_set_year(@flags_pointer, "2013")
    LAME.id3tag_set_comment(@flags_pointer, "comment")
    LAME.id3tag_set_track(@flags_pointer, "42")

    encode_wav_file

    Mp3Info.open(mp3_path) do |info|
      info.hastag1?.should be_true
      info.hastag2?.should be_false

      tags = info.tag1
      tags["title"].should    eql "title"
      tags["artist"].should   eql "artist"
      tags["album"].should    eql "album"
      tags["year"].should     eql 2013
      tags["comments"].should eql "comment"
      tags["tracknum"].should eql 42
    end
  end

  xit "adds id3v2 tags if configured to" do
    LAME.id3tag_add_v2(@flags_pointer)
    # Have to prepend the file with the id3v2 frame ourselves..
  end

  private

  def encode_wav_file
    File.open(mp3_path, "wb") do |file|
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
          @flags_pointer,
          left_buffer, right_buffer, input_buffer_size,
          buffer, max_buffer_size
        )

        # write to file
        file.write buffer.get_bytes(0, size)
      end

      # flush final frame
      size = LAME.lame_encode_flush(@flags_pointer, buffer, max_buffer_size)
      file.write buffer.get_bytes(0, size)

      # write "lametag" frame with extra info
      size = LAME.lame_get_lametag_frame(@flags_pointer, buffer, max_buffer_size)
      file.seek(0)
      file.write buffer.get_bytes(0, size)
    end

    LAME.lame_close(@flags_pointer)
  end

end
