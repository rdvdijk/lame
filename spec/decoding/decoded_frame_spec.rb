require 'spec_helper'

module LAME
  module Decoding
    describe DecodedFrame do

      it "is initialized with left and right samples" do
        left = double("left")
        right = double("right")

        decoded_frame = DecodedFrame.new(left, right)

        expect(decoded_frame.left).to eql left
        expect(decoded_frame.right).to eql right
      end

      it "can be built with FFI Buffers" do
        left_buffer = ::FFI::MemoryPointer.new(:short, 4)
        right_buffer = ::FFI::MemoryPointer.new(:short, 4)

        left_buffer.put_array_of_short(0, [1,2,3,4])
        right_buffer.put_array_of_short(0, [5,6,7,8])

        decoded_frame = DecodedFrame.from_short_buffers(left_buffer, right_buffer)

        expect(decoded_frame.left).to eql [1,2,3,4]
        expect(decoded_frame.right).to eql [5,6,7,8]
      end

      describe "#samples" do

        it "returns zipped version of samples" do
          left = [1,2,3,4]
          right = [5,6,7,8]

          decoded_frame = DecodedFrame.new(left, right)

          expect(decoded_frame.samples).to eql [[1,5],[2,6],[3,7],[4,8]]
        end
      end

    end
  end
end
