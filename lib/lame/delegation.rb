module LAME
  module Delegation

    def delegate_to_lame(*delegations)
      delegations.each do |flag|
        define_setter_delegator(flag, flag)
        define_getter_delegator(flag, flag)
      end
    end

    def delegate_alias_to_lame(delegations)
      delegations.each_pair do |from, to|
        define_setter_delegator(from, to)
        define_getter_delegator(from, to)
      end
    end

    def delegate_id3_to_lame(*delegations)
      delegations.each do |flag|
        define_setter_delegator(flag, flag, "id3tag")
      end
    end

    private

    def define_setter_delegator(from, to, preset = "lame")
      define_method(:"#{from}=") do |value|
        value = TypeConvertor.convert(value)
        LAME.send(:"#{preset}_set_#{to}", global_flags, value)
      end
    end

    def define_getter_delegator(from, to, preset = "lame")
      define_method(:"#{from}") do
        LAME.send(:"#{preset}_get_#{to}", global_flags)
      end
      define_method(:"#{from}?") do
        return_value = send(:"#{from}")
        TypeConvertor.convert_return(return_value)
      end
    end

    class TypeConvertor
      def self.convert(value)
        case value
        when true
          1
        when false
          0
        when String
          ::FFI::MemoryPointer.from_string(value)
        else
          value
        end
      end

      def self.convert_return(value)
        case value
        when 0
          false
        else
          !!value
        end
      end
    end

  end
end
