require 'spec_helper'

module LAME
  describe Buffer do

    it "creates a buffer of given size and type" do
      input = [-42, 0, 42]
      buffer = Buffer.create(:short, input)

      buffer.should be_a(::FFI::MemoryPointer)
      buffer.size.should eql 6 # shorts are two bytes
      buffer.type_size.should eql 2
      buffer.get_array_of_short(0, 3).should eql [-42, 0, 42]
    end

    it "creates an empty buffer" do
      buffer = Buffer.create_empty(:uchar, 100)

      buffer.should be_a(::FFI::MemoryPointer)
      buffer.size.should eql 100
      buffer.type_size.should eql 1
      buffer.get_array_of_uchar(0, 100).should eql [0]*100
    end

  end
end
