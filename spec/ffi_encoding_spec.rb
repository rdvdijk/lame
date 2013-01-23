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

      context "closing" do
        it "closes" do
          LAME.lame_close(@flags_pointer).should eql 0
        end
      end
    end

  end
end
