module LAME
  module FFI
    module Enums

      def self.included(base)
        base.class_eval do

          enum :vbr_mode, [
            :vbr_off, 0,
            :vbr_mt,
            :vbr_rh,
            :vbr_abr,
            :vbr_default, 4, # two enums with value 4
            :vbr_mtrh, 4,
            :vbr_max_indicator
          ]

          enum :mpeg_mode, [
            :stereo, 0,
            :joint_stereo,
            :dual_channel, # unsupported
            :mono,
            :not_set,
            :max_indicator # used internally
          ]

          enum :preset_mode, [
            # FhG style:
            # These double enum values break in jruby-19mode.
            # Internally FFI uses hashes, jruby might have implemented this differently?
            # :VBR_10,  410,
            # :VBR_20,  420,
            # :VBR_30,  430,
            # :VBR_40,  440,
            # :VBR_50,  450,
            # :VBR_60,  460,
            # :VBR_70,  470,
            # :VBR_80,  480,
            # :VBR_90,  490,
            # :VBR_100, 500,

            # LAME style:
            :V9, 410,
            :V8, 420,
            :V7, 430,
            :V6, 440,
            :V5, 450,
            :V4, 460,
            :V3, 470,
            :V2, 480,
            :V1, 490,
            :V0, 500,

            # old presets:
            :R3MIX,         1000,
            :STANDARD,      1001,
            :EXTREME,       1002,
            :INSANE,        1003,
            :STANDARD_FAST, 1004,
            :EXTREME_FAST,  1005,
            :MEDIUM,        1006,
            :MEDIUM_FAST,   1007
          ]

          enum :asm_optimizations, [
            :MMX,       1,
            :AMD_3DNOW, 2,
            :SSE,       3
          ]
        end
      end

    end
  end
end
