require 'spec_helper'

module LAME
  describe Buffer do

    it "creates a buffer of given size and type" do
      input = [-42, 0, 42]
      buffer = Buffer.create(:short, input)

      expect(buffer).to be_a(::FFI::MemoryPointer)
      expect(buffer.size).to eql 6 # shorts are two bytes
      expect(buffer.type_size).to eql 2
      expect(buffer.get_array_of_short(0, 3)).to eql [-42, 0, 42]
    end

    it "creates an empty buffer" do
      buffer = Buffer.create_empty(:uchar, 100)

      expect(buffer).to be_a(::FFI::MemoryPointer)
      expect(buffer.size).to eql 100
      expect(buffer.type_size).to eql 1
      expect(buffer.get_array_of_uchar(0, 100)).to eql [0]*100
    end

  end
end
