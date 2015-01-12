require 'spec_helper'

module LAME
  module Decoding
    describe MPEGAudioFrameMatcher do

      B_EMPTY      = 0b00000000

      B1_LEADING   = 0b11111111
      B2_LEADING   = 0b11100000
      B2_MPEG25    = 0b00000000
      B2_MPEG_RESV = 0b00001000
      B2_MPEG2     = 0b00010000
      B2_MPEG1     = 0b00011000
      B2_LAYER0    = 0b00000000 # reserved
      B2_LAYER3    = 0b00000010 # Layer III
      B2_LAYER2    = 0b00000100 # Layer II
      B2_LAYER1    = 0b00000110 # Layer I

      # Comments below are for MP3
      B3_BITRATE0  = 0b00000000
      B3_BITRATE1  = 0b00010000 # lowest (32 in MP3)
      B3_BITRATE9  = 0b10010000 # 128kbit in MP3
      B3_BITRATE11 = 0b10110000 # 192kbit in MP3
      B3_BITRATE14 = 0b11100000 # highest (320 in MP3)
      B3_BITRATE15 = 0b11110000
      B3_SMPRATE0  = 0b00000000 # 44100
      B3_SMPRATE1  = 0b00000100 # 48000
      B3_SMPRATE2  = 0b00001000 # 32000
      B3_SMPRATE3  = 0b00001100 # reserved

      B4_STEREO    = 0b00000000
      B4_JOINT     = 0b01000000
      B4_DUAL      = 0b10000000
      B4_MONO      = 0b11000000
      B4_EMPH_NONE = 0b00000000
      B4_EMPH_5015 = 0b00000001
      B4_EMPH_RESV = 0b00000010 # reserved
      B4_EMPH_CCIT = 0b00000011

      shared_examples_for "4 valid bytes" do
        it "matches" do
          bytes = [b1, b2, b3, b4].pack("C*")
          expect(MPEGAudioFrameMatcher.new(bytes).match?).to be_truthy
        end
      end

      shared_examples_for "4 invalid bytes" do
        it "does not match" do
          bytes = [b1, b2, b3, b4].pack("C*")
          expect(MPEGAudioFrameMatcher.new(bytes).match?).to be_falsy
        end
      end

      context "MPEG1, Layer III, 128kbit, 44khz, stereo, no-emph" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER3 }
        let(:b3) { B3_BITRATE9 | B3_SMPRATE0 }
        let(:b4) { B4_STEREO | B4_EMPH_NONE }

        it_behaves_like "4 valid bytes"
      end

      context "MPEG2, Layer II, 160kbit, 24khz, mono, 50/15ms emph" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG2 | B2_LAYER2 }
        let(:b3) { B3_BITRATE14 | B3_SMPRATE1 }
        let(:b4) { B4_MONO | B4_EMPH_5015 }

        it_behaves_like "4 valid bytes"
      end

      context "all 0 bites" do
        let(:b1) { B_EMPTY }
        let(:b2) { B_EMPTY }
        let(:b3) { B_EMPTY }
        let(:b4) { B_EMPTY }

        it_behaves_like "4 invalid bytes"
      end

      context "reserved MPEG" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG_RESV | B2_LAYER3 } # <-- B2_MPEG_RESV
        let(:b3) { B3_BITRATE9 | B3_SMPRATE0 }
        let(:b4) { B4_STEREO | B4_EMPH_NONE }

        it_behaves_like "4 invalid bytes"
      end

      context "reserved Layer" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER0 } # <-- B2_LAYER0
        let(:b3) { B3_BITRATE9 | B3_SMPRATE0 }
        let(:b4) { B4_STEREO | B4_EMPH_NONE }

        it_behaves_like "4 invalid bytes"
      end

      context "reserved bitrate" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER3 }
        let(:b3) { B3_BITRATE15 | B3_SMPRATE0 } # <-- B3_BITRATE15
        let(:b4) { B4_STEREO | B4_EMPH_NONE }

        it_behaves_like "4 invalid bytes"
      end

      context "reserved sampling rate" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER3 }
        let(:b3) { B3_BITRATE9 | B3_SMPRATE3 } # <-- B3_SMPRATE3
        let(:b4) { B4_STEREO | B4_EMPH_NONE }

        it_behaves_like "4 invalid bytes"
      end

      context "valid MPEG1 Layer II bitrate/channel mode combination" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER2 }
        let(:b3) { B3_BITRATE1 | B3_SMPRATE2 }
        let(:b4) { B4_MONO | B4_EMPH_NONE }

        # bitrate '1' and 'mono' is valid
        it_behaves_like "4 valid bytes"
      end

      context "another valid MPEG1 Layer II bitrate/channel mode combination" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER2 }
        let(:b3) { B3_BITRATE11 | B3_SMPRATE2 }
        let(:b4) { B4_JOINT | B4_EMPH_NONE }

        # bitrate '11' and 'joint_stereo' is valid
        it_behaves_like "4 valid bytes"
      end

      context "yet another valid MPEG1 Layer II bitrate/channel mode combination" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER2 }
        let(:b3) { B3_BITRATE9 | B3_SMPRATE2 }
        let(:b4) { B4_JOINT | B4_EMPH_NONE }

        # bitrate '9' and 'joint_stereo' is valid
        it_behaves_like "4 valid bytes"
      end

      context "invalid MPEG1 Layer II bitrate/channel mode combination" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER2 }
        let(:b3) { B3_BITRATE1 | B3_SMPRATE2 }
        let(:b4) { B4_STEREO | B4_EMPH_NONE }

        # bitrate '1' and 'stereo' is invalid
        it_behaves_like "4 invalid bytes"
      end

      context "another invalid MPEG1 Layer II bitrate/channel mode combination" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER2 }
        let(:b3) { B3_BITRATE11 | B3_SMPRATE2 }
        let(:b4) { B4_MONO | B4_EMPH_NONE }

        # bitrate '11' and 'mono' is invalid
        it_behaves_like "4 invalid bytes"
      end

      context "invalid emphasis" do
        let(:b1) { B1_LEADING }
        let(:b2) { B2_LEADING | B2_MPEG1 | B2_LAYER3 }
        let(:b3) { B3_BITRATE9 | B3_SMPRATE0 }
        let(:b4) { B4_STEREO | B4_EMPH_RESV }

        it_behaves_like "4 invalid bytes"
      end

    end
  end
end
