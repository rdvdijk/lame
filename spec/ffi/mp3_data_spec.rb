require 'spec_helper'

module LAME
  module FFI
    describe MP3Data do

      subject(:mp3_data) { MP3Data.new }

      it "is stereo for two channels" do
        mp3_data[:stereo] = 2
        expect(mp3_data.channel_mode).to eql :stereo
      end

      it "is mono for one channel" do
        mp3_data[:stereo] = 1
        expect(mp3_data.channel_mode).to eql :mono
      end

      it "has a sample rate" do
        mp3_data[:samplerate] = 44100
        expect(mp3_data.sample_rate).to eql 44100
      end

    end
  end
end
