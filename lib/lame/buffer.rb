module LAME
  class Buffer

    def self.create(type, input)
      buffer = ::FFI::MemoryPointer.new(type, input.size)
      buffer.put_array_of_short(0, input)
      buffer
    end

    def self.create_empty(type, size)
      ::FFI::MemoryPointer.new(type, size)
    end

  end
end
