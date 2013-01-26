module LAME
  module Delegation

    def delegate_to_lame(delegations)
      delegations.each_pair do |from, to|

        define_method(:"#{from}=") do |value|
          LAME.send(:"lame_set_#{to}", global_flags, value)
        end

        define_method(:"#{from}") do
          LAME.send(:"lame_get_#{to}", global_flags)
        end

      end
    end

  end
end
