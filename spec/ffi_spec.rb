require 'spec_helper'
require 'pry'

module LAME
  describe "FFI calls" do

    before do
      @flags_pointer = LAME.lame_init
    end

    context "global flags" do

      it "gets the number of samples" do
        LAME.lame_get_num_samples(@flags_pointer).should eql 2**32-1
      end

      it "sets the number of samples" do
        LAME.lame_set_num_samples(@flags_pointer, 1).should eql 0
        LAME.lame_get_num_samples(@flags_pointer).should eql 1
      end

      it "gets the input samplerate" do
        LAME.lame_get_in_samplerate(@flags_pointer).should eql 44100
      end

      it "sets the input samplerate" do
        LAME.lame_set_in_samplerate(@flags_pointer, 22050).should eql 0
        LAME.lame_get_in_samplerate(@flags_pointer).should eql 22050
      end

      it "gets the number of channels" do
        LAME.lame_get_num_channels(@flags_pointer).should eql 2
      end

      it "sets the number of channels" do
        LAME.lame_set_num_channels(@flags_pointer, 1).should eql 0
        LAME.lame_get_num_channels(@flags_pointer).should eql 1
      end

      it "gets the scale" do
        LAME.lame_get_scale(@flags_pointer).should eql 1.0
      end

      it "sets the scale" do
        LAME.lame_set_scale(@flags_pointer, 2.0).should eql 0
        LAME.lame_get_scale(@flags_pointer).should eql 2.0
      end

      it "gets the scale_left" do
        LAME.lame_get_scale_left(@flags_pointer).should eql 1.0
      end

      it "sets the scale_left" do
        LAME.lame_set_scale_left(@flags_pointer, 2.0).should eql 0
        LAME.lame_get_scale_left(@flags_pointer).should eql 2.0
      end

      it "gets the scale_right" do
        LAME.lame_get_scale_right(@flags_pointer).should eql 1.0
      end

      it "sets the scale_right" do
        LAME.lame_set_scale_right(@flags_pointer, 2.0).should eql 0
        LAME.lame_get_scale_right(@flags_pointer).should eql 2.0
      end

      it "gets the output samplerate" do
        LAME.lame_get_out_samplerate(@flags_pointer).should eql 0
      end

      it "sets the output samplerate" do
        LAME.lame_set_out_samplerate(@flags_pointer, 48000).should eql 0
        LAME.lame_get_out_samplerate(@flags_pointer).should eql 48000
      end

      it "gets the analysis" do
        LAME.lame_get_analysis(@flags_pointer).should eql 0
      end

      it "sets the analysis" do
        LAME.lame_set_analysis(@flags_pointer, 1).should eql 0
        LAME.lame_get_analysis(@flags_pointer).should eql 1
      end

      it "gets bWriteVbrTag" do
        LAME.lame_get_bWriteVbrTag(@flags_pointer).should eql 1
      end

      it "sets bWriteVbrTag" do
        LAME.lame_set_bWriteVbrTag(@flags_pointer, 0).should eql 0
        LAME.lame_get_bWriteVbrTag(@flags_pointer).should eql 0
      end

      it "gets decode only" do
        LAME.lame_get_decode_only(@flags_pointer).should eql 0
      end

      it "sets decode only" do
        LAME.lame_set_decode_only(@flags_pointer, 0).should eql 0
        LAME.lame_get_decode_only(@flags_pointer).should eql 0
      end

      it "gets the quality" do
        LAME.lame_get_quality(@flags_pointer).should eql -1
      end

      it "sets the quality" do
        LAME.lame_set_quality(@flags_pointer, 1).should eql 0
        LAME.lame_get_quality(@flags_pointer).should eql 1
      end

      it "gets the mode" do
        LAME.lame_get_mode(@flags_pointer).should eql 4
      end

      it "sets the mode" do
        LAME.lame_set_mode(@flags_pointer, 1).should eql 0
        LAME.lame_get_mode(@flags_pointer).should eql 1
      end

      it "gets force ms" do
        LAME.lame_get_force_ms(@flags_pointer).should eql 0
      end

      it "sets force ms" do
        LAME.lame_set_force_ms(@flags_pointer, 1).should eql 0
        LAME.lame_get_force_ms(@flags_pointer).should eql 1
      end

      it "gets free format" do
        LAME.lame_get_free_format(@flags_pointer).should eql 0
      end

      it "sets free format" do
        LAME.lame_set_free_format(@flags_pointer, 1).should eql 0
        LAME.lame_get_free_format(@flags_pointer).should eql 1
      end

      it "gets find replay gain" do
        LAME.lame_get_findReplayGain(@flags_pointer).should eql 0
      end

      it "sets find replay gain" do
        LAME.lame_set_findReplayGain(@flags_pointer, 1).should eql 0
        LAME.lame_get_findReplayGain(@flags_pointer).should eql 1
      end

      it "gets decode on the fly" do
        LAME.lame_get_decode_on_the_fly(@flags_pointer).should eql 0
      end

      it "sets decode on the fly" do
        LAME.lame_set_decode_on_the_fly(@flags_pointer, 1).should eql 0
        LAME.lame_get_decode_on_the_fly(@flags_pointer).should eql 1
      end

      it "gets nogap total" do
        LAME.lame_get_nogap_total(@flags_pointer).should eql 0
      end

      it "sets nogap total" do
        LAME.lame_set_nogap_total(@flags_pointer, 1).should eql 0
        LAME.lame_get_nogap_total(@flags_pointer).should eql 1
      end

      it "gets nogap current index" do
        LAME.lame_get_nogap_currentindex(@flags_pointer).should eql 0
      end

      it "sets nogap current index" do
        LAME.lame_set_nogap_currentindex(@flags_pointer, 1).should eql 0
        LAME.lame_get_nogap_currentindex(@flags_pointer).should eql 1
      end

      # TODO:
      it "sets errorf"
      it "sets debugf"
      it "sets msgf"

      it "gets the brate" do
        LAME.lame_get_brate(@flags_pointer).should eql 0
      end

      it "sets the brate" do
        LAME.lame_set_brate(@flags_pointer, 1).should eql 0
        LAME.lame_get_brate(@flags_pointer).should eql 1
      end

      it "gets the compression ratio" do
        LAME.lame_get_compression_ratio(@flags_pointer).should eql 1
      end

      it "sets the compression ratio" do
        LAME.lame_set_compression_ratio(@flags_pointer, 1).should eql 0
        LAME.lame_get_compression_ratio(@flags_pointer).should eql 1
      end

      it "sets the preset" do
        LAME.lame_set_preset(@flags_pointer, 500).should eql 500
      end

      it "sets asm optimizations" do
        LAME.lame_set_asm_optimizations(@flags_pointer, 1, 2).should eql 1
      end

    end

    context "initialization" do

      it "initializes the parameters" do
        LAME.lame_init_params(@flags_pointer).should eql 0
      end

    end

    context "after parameter initialization" do

      before do
        LAME.lame_init_params(@flags_pointer)
      end

      it "gets the framesize" do
        LAME.lame_get_framesize(@flags_pointer).should eql 1152
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
          length = 2048
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
