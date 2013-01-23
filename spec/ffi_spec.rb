require 'spec_helper'
require 'pry'

module LAME
  describe "FFI calls" do

    before do
      @flags_pointer = LAME.lame_init
    end

    after do
      LAME.lame_close(@flags_pointer)
    end

    context "initialization" do
      it "initializes the parameters" do
        LAME.lame_init_params(@flags_pointer).should eql 0
      end
    end

    context "encoding" do

      before do
        LAME.lame_init_params(@flags_pointer)
      end

      context "encoding" do
        it "encodes short-buffers" do
          length = 4096
          left  = FFI::MemoryPointer.new(:short, length)
          right = FFI::MemoryPointer.new(:short, length)

          buffer_size = (128*1024)+16384 # see LAME_MAXMP3BUFFER in lame.h
          buffer = FFI::MemoryPointer.new(:uchar, buffer_size)

          return_code = LAME.lame_encode_buffer(@flags_pointer, left, right, length, buffer, buffer_size) #.should eql 0
          return_code.should >= 0
        end
      end

      context "flushing" do
        it "flushes" do
          buffer_size = (128*1024)+16384 # see LAME_MAXMP3BUFFER in lame.h
          buffer = FFI::MemoryPointer.new(:uchar, buffer_size)
          LAME.lame_encode_flush(@flags_pointer, buffer, buffer_size).should be >= 0
        end

        it "flushes nogap" do
          length = LAME.lame_get_framesize(@flags_pointer) * 2
          left  = FFI::MemoryPointer.new(:short, length)
          right = FFI::MemoryPointer.new(:short, length)

          buffer_size = (128*1024)+16384 # see LAME_MAXMP3BUFFER in lame.h
          buffer = FFI::MemoryPointer.new(:uchar, buffer_size)

          # encode something so the flush doesn't give an error
          LAME.lame_encode_buffer(@flags_pointer, left, right, length, buffer, buffer_size)

          LAME.lame_encode_flush_nogap(@flags_pointer, buffer, buffer_size).should >= 0
        end
      end

      context "closing" do
        it "closes" do
          LAME.lame_close(@flags_pointer).should eql 0
        end
      end
    end

  end
end
