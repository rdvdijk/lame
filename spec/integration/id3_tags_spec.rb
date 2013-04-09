require 'spec_helper'
require 'wavefile'
require 'mp3info'

describe "ID3 tags", :slow => true do

  let(:wav_file) { WaveFileGenerator.new(:length => 2).generate }
  let(:wav_path) { wav_file.path }
  let(:mp3_id3_path) { File.expand_path(File.join(File.dirname(__FILE__), '../files/dies-irae-id3-raw.mp3')) }
  let(:wav_reader)   { WaveFile::Reader.new(wav_path) }

  it "adds id3v1 tags" do
    encode_wav_file(false)

    Mp3Info.open(mp3_id3_path) do |info|
      info.hastag1?.should be_true
      info.hastag2?.should be_false

      tags = info.tag1
      tags["title"].should    eql "title"
      tags["artist"].should   eql "artist"
      tags["album"].should    eql "album"
      tags["year"].should     eql 2013
      tags["comments"].should eql "comment"
      tags["tracknum"].should eql 42
      tags["genre_s"].should  eql "Rock"
    end
  end

  it "adds id3v2 tags if configured to" do
    encode_wav_file

    Mp3Info.open(mp3_id3_path) do |info|
      info.hastag1?.should be_true
      info.hastag2?.should be_true

      tags = info.tag2
      tags["TIT2"].should eql "title"
      tags["TPE1"].should eql "artist"
      tags["TALB"].should eql "album"
      tags["TYER"].should eql "2013"
      tags["COMM"].should eql "comment"
      tags["TRCK"].should eql "42"
      tags["TCON"].should eql "Rock"
    end
  end

  private

  def encode_wav_file(enable_id3v2 = true)
    encoder = LAME::Encoder.new

    encoder.configure do |config|
      config.id3.write_automatic = false
      config.id3.v2 = enable_id3v2
      config.id3.title   = "title"
      config.id3.artist  = "artist"
      config.id3.album   = "album"
      config.id3.year    = "2013"
      config.id3.comment = "comment"
      config.id3.track   = "42"
      config.id3.genre   = "Rock"
    end

    File.open(mp3_id3_path, "wb") do |file|

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
  end

end
