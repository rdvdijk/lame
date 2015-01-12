require 'spec_helper'

module LAME
  module Decoding
    describe MPEGAudioFrameFinder do

      subject(:finder) { MPEGAudioFrameFinder.new(stream) }

      let(:stream) { StringIO.new(stream_string) }
      let(:stream_string) { "1234567890" }

      it "tries to find the mpeg frame 4 bytes at a time until a header is found" do
        matcher1 = double("matcher", :match? => false)
        matcher2 = double("matcher", :match? => false)
        matcher3 = double("matcher", :match? => true)

        expect(MPEGAudioFrameMatcher).to receive(:new).with("1234").and_return(matcher1)
        expect(MPEGAudioFrameMatcher).to receive(:new).with("2345").and_return(matcher2)
        expect(MPEGAudioFrameMatcher).to receive(:new).with("3456").and_return(matcher3)

        finder.find!
      end

      it "seeks the stream at the position of the found frame" do
        matcher1 = double("matcher", :match? => false)
        matcher2 = double("matcher", :match? => false)
        matcher3 = double("matcher", :match? => true)

        allow(MPEGAudioFrameMatcher).to receive(:new).with("1234").and_return(matcher1)
        allow(MPEGAudioFrameMatcher).to receive(:new).with("2345").and_return(matcher2)
        allow(MPEGAudioFrameMatcher).to receive(:new).with("3456").and_return(matcher3)

        finder.find!

        expect(stream.pos).to eql 2
      end

      it "raises an error if no header could be found" do
        matcher = double("matcher", :match? => false)

        allow(MPEGAudioFrameMatcher).to receive(:new).and_return(matcher)

        expect {
          finder.find!
        }.to raise_error(MPEGAudioFrameNotFoundError)
      end

    end
  end
end
