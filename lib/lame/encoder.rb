module LAME
  class Encoder
    extend Delegation

    attr_reader :global_flags

    delegate_to_lame :number_of_samples => :num_samples,
      :input_samplerate => :in_samplerate

    def initialize
      @global_flags = FFI::GlobalFlags.new
    end

  end
end
