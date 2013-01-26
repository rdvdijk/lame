module LAME
  module FFI

    class Version < ::FFI::Struct
      layout  :major, :int,
        :minor, :int,
        :alpha, :int,
        :beta, :int,
        :psy_major, :int,
        :psy_minor, :int,
        :psy_alpha, :int,
        :psy_beta, :int,
        :features, :string

    end
  end
end
