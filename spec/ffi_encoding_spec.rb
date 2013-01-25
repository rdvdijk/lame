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

      it "inits the bitstream" do
        LAME.lame_init_bitstream(@flags_pointer).should eql 0
      end

    end

    context "encoding" do

      before do
        LAME.lame_init_params(@flags_pointer)
      end

      let(:input_buffer_size) { LAME.lame_get_framesize(@flags_pointer) * 2 }

      let(:input_buffer_left)  { FFI::MemoryPointer.new(input_type, input_buffer_size) }
      let(:input_buffer_right) { FFI::MemoryPointer.new(input_type, input_buffer_size) }
      let(:input_buffer_interleaved) { FFI::MemoryPointer.new(input_type, input_buffer_size*2) }

      let(:output_buffer_size) { (128*1024)+16384 } # see LAME_MAXMP3BUFFER in lame.h
      let(:output_buffer)      { FFI::MemoryPointer.new(:uchar, output_buffer_size) }

      context "encoding" do

        context "short-buffer" do
          let(:input_type) { :short }

          it "encodes" do
            return_code = LAME.lame_encode_buffer(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)
            return_code.should >= 0
          end
        end

        context "float-buffer" do
          let(:input_type) { :float }

          it "encodes" do
            return_code = LAME.lame_encode_buffer_float(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)
            return_code.should >= 0
          end
        end

        context "ieee float-buffer" do
          let(:input_type) { :float }

          it "encodes" do
            return_code = LAME.lame_encode_buffer_ieee_float(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)
            return_code.should >= 0
          end
        end

        context "ieee double-buffer" do
          let(:input_type) { :double }

          it "encodes" do
            return_code = LAME.lame_encode_buffer_ieee_double(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)
            return_code.should >= 0
          end
        end

        context "long-buffer" do
          let(:input_type) { :long }

          it "encodes" do
            return_code = LAME.lame_encode_buffer_long(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)
            return_code.should >= 0
          end
        end

        context "long-buffer" do
          let(:input_type) { :long }

          it "encodes" do
            return_code = LAME.lame_encode_buffer_long2(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)
            return_code.should >= 0
          end
        end

        context "int-buffer" do
          let(:input_type) { :int }

          it "encodes" do
            return_code = LAME.lame_encode_buffer_int(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)
            return_code.should >= 0
          end
        end

        context "interleaved" do

          context "ieee float-buffer" do
            let(:input_type) { :float }

            it "encodes" do
              return_code = LAME.lame_encode_buffer_interleaved_ieee_float(@flags_pointer, input_buffer_interleaved, input_buffer_size, output_buffer, output_buffer_size)
              return_code.should >= 0
            end
          end

          context "ieee double-buffer" do
            let(:input_type) { :double }

            it "encodes" do
              return_code = LAME.lame_encode_buffer_interleaved_ieee_double(@flags_pointer, input_buffer_interleaved, input_buffer_size, output_buffer, output_buffer_size)
              return_code.should >= 0
            end
          end

        end

      end

      context "flushing" do
        let(:input_type) { :short }

        it "flushes" do
          LAME.lame_encode_flush(@flags_pointer, output_buffer, output_buffer_size).should be >= 0
        end

        it "flushes nogap" do
          # encode something so the flush doesn't give an error
          LAME.lame_encode_buffer(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)

          LAME.lame_encode_flush_nogap(@flags_pointer, output_buffer, output_buffer_size).should >= 0
        end
      end

      context "lametag frame" do
        let(:input_type) { :short }

        it "creates a lametag frame" do
          # encode something so there is a lametag frame with VBR info
          # (0..input_buffer_size).each do |index|
          #   input_buffer_left.put_short(index, rand(2**15)-2**14)
          #   input_buffer_right.put_short(index, rand(2**15)-2**14)
          # end

          LAME.lame_encode_buffer(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)

          frame_size = LAME.lame_get_lametag_frame(@flags_pointer, output_buffer, output_buffer_size)
          #p output_buffer.get_bytes(0, frame_size)
          frame_size.should eql 417
        end
      end

      context "history statistics" do
        let(:input_type) { :short }

        before do
          LAME.lame_encode_buffer(@flags_pointer, input_buffer_left, input_buffer_right, input_buffer_size, output_buffer, output_buffer_size)
        end

        it "has bitrate history" do
          bitrate_count_ptr = FFI::MemoryPointer.new(:int, 14)
          LAME.lame_bitrate_hist(@flags_pointer, bitrate_count_ptr)

          bitrate_count = bitrate_count_ptr.read_array_of_int(14)
          # 9th = 128 (see below)
          bitrate_count.should eql [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]
        end

        it "has bitrate kbps" do
          bitrate_kbps_ptr = FFI::MemoryPointer.new(:int, 14)
          LAME.lame_bitrate_kbps(@flags_pointer, bitrate_kbps_ptr)

          bitrate_kbps = bitrate_kbps_ptr.read_array_of_int(14)
          # 9th = 128 (see bitrate table, without 0)
          bitrate_kbps.should eql [32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320]
        end

        it "has stereo mode hist" do
          stereo_mode_hist_ptr = FFI::MemoryPointer.new(:int, 4)
          LAME.lame_stereo_mode_hist(@flags_pointer, stereo_mode_hist_ptr)

          stereo_mode_hist = stereo_mode_hist_ptr.read_array_of_int(4)
          # see lame.h for meaning
          stereo_mode_hist.should eql [0, 0, 1, 0]
        end

        it "has bitrate stereo mode hist" do
          pending "multi-dimensional array"
        end

        it "has block type hist" do
          block_type_hist_ptr = FFI::MemoryPointer.new(:int, 6)
          LAME.lame_block_type_hist(@flags_pointer, block_type_hist_ptr)

          block_type_hist = block_type_hist_ptr.read_array_of_int(6)
          # see lame.h for meaning
          block_type_hist.should eql [4, 0, 0, 0, 0, 4]
        end

        it "has bitrate block type hist" do
          pending "multi-dimensional array"
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
