module LAME
  module Delegation

    def delegate_alias_to_lame(delegations)
      delegations.each_pair do |from, to|
        define_setter_delegator(from, to)
        define_getter_delegator(from, to)
      end
    end

    def delegate_to_lame(*delegations)
      delegations.each do |flag|
        define_setter_delegator(flag, flag)
        define_getter_delegator(flag, flag)
      end
    end

    private

    def define_setter_delegator(from, to)
      define_method(:"#{from}=") do |value|
        # TODO: value conversion (booleans, strings)
        LAME.send(:"lame_set_#{to}", global_flags, value)
      end
    end

    def define_getter_delegator(from, to)
      define_method(:"#{from}") do
        LAME.send(:"lame_get_#{to}", global_flags)
      end
    end

  end
end
