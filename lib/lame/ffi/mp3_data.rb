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

    end
  end
end


