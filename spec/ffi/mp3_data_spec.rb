require 'spec_helper'

module LAME
  module FFI
    describe MP3Data do

      subject(:mp3_data) { MP3Data.new }

      it "is stereo for two channels" do
        mp3_data[:stereo] = 2
        mp3_data.channel_mode.should eql :stereo
      end

      it "is mono for one channel" do
        mp3_data[:stereo] = 1
        mp3_data.channel_mode.should eql :mono
      end

      it "has a sample rate" do
        mp3_data[:samplerate] = 44100
        mp3_data.sample_rate.should eql 44100
      end

    end
  end
end
