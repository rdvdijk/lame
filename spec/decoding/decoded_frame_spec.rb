require 'spec_helper'

module LAME
  module Decoding
    describe DecodedFrame do

      it "is initialized with left and right samples" do
        left = stub
        right = stub

        decoded_frame = DecodedFrame.new(left, right)

        decoded_frame.left.should eql left
        decoded_frame.right.should eql right
      end

      it "can be built with FFI Buffers" do
        left_buffer = ::FFI::MemoryPointer.new(:short, 4)
        right_buffer = ::FFI::MemoryPointer.new(:short, 4)

        left_buffer.put_array_of_short(0, [1,2,3,4])
        right_buffer.put_array_of_short(0, [5,6,7,8])

        decoded_frame = DecodedFrame.from_short_buffers(left_buffer, right_buffer)

        decoded_frame.left.should eql [1,2,3,4]
        decoded_frame.right.should eql [5,6,7,8]
      end

      describe "#samples" do

        it "returns zipped version of samples" do
          left = [1,2,3,4]
          right = [5,6,7,8]

          decoded_frame = DecodedFrame.new(left, right)

          decoded_frame.samples.should eql [[1,5],[2,6],[3,7],[4,8]]
        end
      end

    end
  end
end
