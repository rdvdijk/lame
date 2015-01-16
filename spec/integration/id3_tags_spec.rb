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
      expect(info.hastag1?).to be_truthy
      expect(info.hastag2?).to be_falsy

      tags = info.tag1
      expect(tags["title"]).to    eql "title"
      expect(tags["artist"]).to   eql "artist"
      expect(tags["album"]).to    eql "album"
      expect(tags["year"]).to     eql 2013
      expect(tags["comments"]).to eql "comment"
      expect(tags["tracknum"]).to eql 42
      expect(tags["genre_s"]).to  eql "Rock"
    end
  end

  it "adds id3v2 tags if configured to" do
    encode_wav_file

    Mp3Info.open(mp3_id3_path) do |info|
      expect(info.hastag1?).to be_truthy
      expect(info.hastag2?).to be_truthy

      tags = info.tag2
      expect(tags["TIT2"]).to eql "title"
      expect(tags["TPE1"]).to eql "artist"
      expect(tags["TALB"]).to eql "album"
      expect(tags["TYER"]).to eql "2013"
      expect(tags["COMM"]).to eql "comment"
      expect(tags["TRCK"]).to eql "42"
      expect(tags["TCON"]).to eql "Rock"
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
