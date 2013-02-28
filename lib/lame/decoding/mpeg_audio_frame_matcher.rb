module LAME
  module Decoding

    # Specification is here:
    # http://www.codeproject.com/Articles/8295/MPEG-Audio-Frame-Header
    #
    # Also see `is_syncword_mp123` in lame-3.99.5/frontend/get_audio.c
    #
    # Get ready for some bit-matching magic:
    class MPEGAudioFrameMatcher

      attr_reader :bytes

      CHANNEL_MODES = [:stereo, :joint_stereo, :dual_channel, :mono]

      def initialize(bytes)
        @bytes = bytes.unpack("C*")
      end

      def match?
        leading_bits? &&
          mpeg? &&
          layer? &&
          bitrate? &&
          sample_frequency? &&
          valid_mpeg1_layer2? &&
          emphasis?
      end

      private

      # First eleven bits (all 1)
      def leading_bits?
        (bytes[0] & 0b11111111) == 0b11111111 &&
          (bytes[1] & 0b11100000) == 0b11100000
      end

      # 4th and 5th bit in second byte (01 is reserved)
      def mpeg?
        (bytes[1] & 0b11000) != 0b01000
      end

      # 6th and 7th bit in second byte (00 is reserved)
      def layer?
        (bytes[1] & 0b110) != 0b000
      end

      # first 4 bits in third byte (all 1's is reserved)
      def bitrate?
        (bytes[2] & 0b11110000) != 0b11110000
      end

      # 5th and 6th bit in third byte (all 1's is reserved)
      def sample_frequency?
        (bytes[2] & 0b1100) != 0b1100
      end

      # http://www.codeproject.com/Articles/8295/MPEG-Audio-Frame-Header#Combinations
      # Only certain combination are valid for MPEG1 Layer II:
      def valid_mpeg1_layer2?
        return true if !mpeg1?
        return true if !layer2?

        bitrate_index = (bytes[2] >> 4)

        case bitrate_index
        when 1,2,3,5
          channel_mode == :mono
        when 11,12,13,14
          [:stereo, :joint_stereo, :dual_channel].include?(channel_mode)
        else
          true
        end
      end

      # 7th and 8th bit in fourth byte (10 is reserved)
      def emphasis?
        (bytes[3] & 0b11) != 0b10
      end

      # MPEG1 = 11
      def mpeg1?
        (bytes[1] & 0b11000) == 0b11000
      end

      # Layer II = 10
      def layer2?
        (bytes[1] & 0b110) == 0b100
      end

      # 1st and 2nd bit of fourth byte
      def channel_mode
        @channel_mode ||= CHANNEL_MODES[bytes[3] >> 6]
      end

    end
  end
end
