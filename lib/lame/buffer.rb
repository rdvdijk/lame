module LAME
  class Buffer

    def self.create(type, input)
      buffer = ::FFI::MemoryPointer.new(type, input.size)
      buffer.send(:"put_array_of_#{type}", 0, input)
      buffer
    end

    def self.create_uchar(input)
      buffer = ::FFI::MemoryPointer.new(:uchar, input.size)
      buffer.put_array_of_uchar(0, input.bytes.to_a)
      buffer
    end

    def self.create_empty(type, size)
      ::FFI::MemoryPointer.new(type, size)
    end

  end
end
