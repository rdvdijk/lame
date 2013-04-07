module LAME
  module FFI
    class MP3Data < ::FFI::Struct

      layout :header_parsed, :int,
        :stereo,      :int,
        :samplerate,  :int,
        :bitrate,     :int,
        :mode,        :int,
        :mod_ext,     :int,
        :framesize,   :int,
        :nsamp,       :ulong,
        :totalframes, :int,
        :framenum,    :int

      def header_parsed?
        self[:header_parsed] == 1
      end

      def channel_mode
        case self[:stereo]
        when 1
          :mono
        when 2
          :stereo
        end
      end

      def sample_rate
        self[:samplerate]
      end

    end
  end
end


