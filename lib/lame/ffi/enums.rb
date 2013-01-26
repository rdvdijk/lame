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
            :vbr_mtrh,
            :vbr_max_indicator
            #:vbr_default, 4 # vbr_mtrh # two enums with value 4?
          ]

        end
      end

    end
  end
end
