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

          # Vx to match LAME and VBR_xx to match FhG
          enum :preset_mode, [
            :VBR_10,  410,
            :V9,      410,
            :VBR_20,  420,
            :V8,      420,
            :VBR_30,  430,
            :V7,      430,
            :VBR_40,  440,
            :V6,      440,
            :VBR_50,  450,
            :V5,      450,
            :VBR_60,  460,
            :V4,      460,
            :VBR_70,  470,
            :V3,      470,
            :VBR_80,  480,
            :V2,      480,
            :VBR_90,  490,
            :V1,      490,
            :VBR_100, 500,
            :V0,      500,

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

        end
      end

    end
  end
end
