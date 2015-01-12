require 'spec_helper'

module LAME
  describe Encoder do

    subject(:encoder) { Encoder.new }

    context "initialization" do

      it "initializes GlobalFlags" do
        expect(FFI::GlobalFlags).to receive(:new)
        Encoder.new
      end

    end

    context "configuration" do

      let(:configuration) { double(Configuration).as_null_object }

      before do
        allow(Configuration).to receive(:new).and_return(configuration)
      end

      it "initializes a Configuration object" do
        expect(Configuration).to receive(:new).with(kind_of(GlobalFlags))
        encoder.configure { }
      end

      it "yields the Configuration object" do
        expect { |block|
          encoder.configure(&block)
        }.to yield_with_args(configuration)
      end

      it "assigns the Configuration object" do
        encoder.configure { }
        expect(encoder.configuration).to eql configuration
      end

      it "applies the configuration" do
        allow(configuration).to receive(:applied?).and_return(false)
        expect(configuration).to receive(:apply!)
        encoder.configure { }
      end

      it "gets the framesize" do
        expect(configuration).to receive(:framesize).and_return(1234)
        expect(encoder.framesize).to eql 1234
      end
    end

    context "encoding" do

      let(:left) { [0] }
      let(:right) { [0] }
      let(:samples) { [0,0] }

      let(:global_flags) { subject.global_flags }
      let(:configuration) { double(Configuration, :framesize => 100) }

      before do
        allow(Configuration).to receive(:new).and_return(configuration)
        allow(configuration).to receive(:applied?).and_return(true)
      end

      describe "#encode_short" do

        before do
          allow(Encoding::ShortBufferEncoder).to receive(:new).and_return(double.as_null_object)
        end

        it "applies the configuration if not done already" do
          allow(configuration).to receive(:applied?).and_return(false)
          expect(configuration).to receive(:apply!)
          encoder.encode_short(left, right) { }
        end

        it "does not apply the configuration if already applied" do
          allow(configuration).to receive(:applied?).and_return(true)
          expect(configuration).to_not receive(:apply!)
          encoder.encode_short(left, right) { }
        end

        context "delegation" do
          let(:short_encoder) { double.as_null_object }

          before do
            allow(Encoding::ShortBufferEncoder).to receive(:new).and_return(short_encoder)
          end

          it "create a short encoder with configuration" do
            expect(Encoding::ShortBufferEncoder).to receive(:new).with(configuration)

            encoder.encode_short(left, right) { }
          end

          it "delegates encoding to the short encoder" do
            allow(left).to receive_messages(:length => 100) # exactly framesize
            expect(short_encoder).to receive(:encode_frame).with(left, right)

            encoder.encode_short(left, right) { }
          end

          it "yields the encoder results" do
            mp3_data = double("mp3_data")
            allow(short_encoder).to receive(:encode_frame).and_return(mp3_data)

            expect { |block|
              encoder.encode_short(left, right, &block)
            }.to yield_with_args(mp3_data)
          end

          it "delegates multiple times for large input" do
            right = left = [0]*150 # larger than framesize

            expect(short_encoder).to receive(:encode_frame) do |left_frame, right_frame|
              expect(left_frame.length).to eql 100
              expect(right_frame.length).to eql 100
            end

            expect(short_encoder).to receive(:encode_frame) do |left_frame, right_frame|
              expect(left_frame.length).to eql 50
              expect(right_frame.length).to eql 50
            end

            encoder.encode_short(left, right) { }
          end

          it "yields multiple times for large input" do
            mp3_data1 = double("frame1")
            mp3_data2 = double("frame2")

            left = [0]*150 # larger than framesize

            allow(short_encoder).to receive(:encode_frame).and_return(mp3_data1, mp3_data2)

            expect { |block|
              encoder.encode_short(left, right, &block)
            }.to yield_successive_args(mp3_data1, mp3_data2)
          end
        end
      end

      describe "#encode_float" do
        it "create a float encoder" do
          allow(Encoding::FloatBufferEncoder).to receive(:new).and_return(double.as_null_object)
          expect(Encoding::FloatBufferEncoder).to receive(:new).with(configuration)

          encoder.encode_float(left, right) { }
        end
      end

      describe "#encode_long" do
        it "create a long encoder" do
          allow(Encoding::LongBufferEncoder).to receive(:new).and_return(double.as_null_object)
          expect(Encoding::LongBufferEncoder).to receive(:new).with(configuration)

          encoder.encode_long(left, right) { }
        end
      end

      describe "#encode_interleaved_short" do

        before do
          allow(Encoding::InterleavedShortBufferEncoder).to receive(:new).and_return(double.as_null_object)
        end

        it "applies the configuration if not done already" do
          allow(configuration).to receive(:applied?).and_return(false)
          expect(configuration).to receive(:apply!)
          encoder.encode_interleaved_short(samples) { }
        end

        it "does not apply the configuration if already applied" do
          allow(configuration).to receive(:applied?).and_return(true)
          expect(configuration).to_not receive(:apply!)
          encoder.encode_interleaved_short(samples) { }
        end

        context "delegation" do
          let(:interleaved_short_encoder) { double.as_null_object }

          before do
            allow(Encoding::InterleavedShortBufferEncoder).to receive(:new).and_return(interleaved_short_encoder)
          end

          it "create a short encoder with configuration" do
            expect(Encoding::InterleavedShortBufferEncoder).to receive(:new).with(configuration)

            encoder.encode_interleaved_short(samples) { }
          end

          it "delegates encoding to the short encoder" do
            allow(samples).to receive_messages(:length => 200) # exactly framesize
            expect(interleaved_short_encoder).to receive(:encode_frame).with(samples)

            encoder.encode_interleaved_short(samples) { }
          end

          it "yields the encoder results" do
            mp3_data = double("mp3_data")
            allow(interleaved_short_encoder).to receive(:encode_frame).and_return(mp3_data)

            expect { |block|
              encoder.encode_interleaved_short(samples, &block)
            }.to yield_with_args(mp3_data)
          end

          it "delegates multiple times for large input" do
            samples = [0]*300 # larger than framesize

            expect(interleaved_short_encoder).to receive(:encode_frame) do |samples|
              expect(samples.length).to eql 200
            end

            expect(interleaved_short_encoder).to receive(:encode_frame) do |samples|
              expect(samples.length).to eql 100
            end

            encoder.encode_interleaved_short(samples) { }
          end

          it "yields multiple times for large input" do
            mp3_data1 = double("frame1")
            mp3_data2 = double("frame2")

            samples = [0]*300 # larger than framesize

            allow(interleaved_short_encoder).to receive(:encode_frame).and_return(mp3_data1, mp3_data2)

            expect { |block|
              encoder.encode_interleaved_short(samples, &block)
            }.to yield_successive_args(mp3_data1, mp3_data2)
          end
        end
      end

      describe "#encode_interleaved_float" do
        it "create a float encoder" do
          allow(Encoding::InterleavedFloatBufferEncoder).to receive(:new).and_return(double.as_null_object)
          expect(Encoding::InterleavedFloatBufferEncoder).to receive(:new).with(configuration)

          encoder.encode_interleaved_float(samples) { }
        end
      end

    end

    context "flushing" do

      let(:global_flags) { subject.global_flags }
      let(:configuration) { double(Configuration) }
      let(:flusher) { double(Encoding::Flusher).as_null_object }

      before do
        allow(Configuration).to receive(:new).and_return(configuration)
        allow(configuration).to receive(:applied?).and_return(true)
        allow(Encoding::Flusher).to receive(:new).and_return(flusher)
      end

      it "creates a flusher" do
        expect(Encoding::Flusher).to receive(:new).with(configuration)
        encoder.flush { }
      end

      it "flushes the final frame" do
        expect(flusher).to receive(:flush)
        encoder.flush { }
      end

      it "yields the flushed mp3 data" do
        mp3_data = double("mp3_data")
        allow(flusher).to receive(:flush).and_return(mp3_data)

        expect { |block|
          encoder.flush(&block)
        }.to yield_with_args(mp3_data)
      end

      it "returns the flushed data if no block was given" do
        mp3_data = double("mp3_data")
        allow(flusher).to receive(:flush).and_return(mp3_data)
        expect(encoder.flush).to eql mp3_data
      end

    end

    context "lametag frame" do

      let(:global_flags) { subject.global_flags }
      let(:configuration) { double(Configuration) }
      let(:vbr_info) { double(Encoding::VBRInfo).as_null_object }

      before do
        allow(Configuration).to receive(:new).and_return(configuration)
        allow(configuration).to receive(:applied?).and_return(true)
        allow(Encoding::VBRInfo).to receive(:new).and_return(vbr_info)
      end

      it "creates vbr info" do
        expect(Encoding::VBRInfo).to receive(:new).with(configuration)
        encoder.vbr_frame { }
      end

      it "creates the vbr frame" do
        expect(vbr_info).to receive(:frame)
        encoder.vbr_frame { }
      end

      it "yields the vbr frame" do
        mp3_data = double("mp3_data")
        allow(vbr_info).to receive(:frame).and_return(mp3_data)

        expect { |block|
          encoder.vbr_frame(&block)
        }.to yield_with_args(mp3_data)
      end

      it "returns the vbr frame if no block was given" do
        mp3_data = double("mp3_data")
        allow(vbr_info).to receive(:frame).and_return(mp3_data)
        expect(encoder.vbr_frame).to eql mp3_data
      end

    end

    context "id3" do
      let(:global_flags) { subject.global_flags }
      let(:configuration) { double(Configuration) }
      let(:id3) { double(Encoding::Id3).as_null_object }

      before do
        allow(Configuration).to receive(:new).and_return(configuration)
        allow(configuration).to receive(:applied?).and_return(true)
        allow(Encoding::Id3).to receive(:new).and_return(id3)
      end

      it "creates vbr info" do
        expect(Encoding::Id3).to receive(:new).with(configuration)
        encoder.id3v1 { }
      end

      context "v1" do
        it "creates the id3v1 frame" do
          expect(id3).to receive(:v1)
          encoder.id3v1 { }
        end

        it "yields the vbr frame" do
          mp3_data = double("mp3_data")
          allow(id3).to receive(:v1).and_return(mp3_data)

          expect { |block|
            encoder.id3v1(&block)
          }.to yield_with_args(mp3_data)
        end

        it "returns the vbr frame if no block was given" do
          mp3_data = double("mp3_data")
          allow(id3).to receive(:v1).and_return(mp3_data)
          expect(encoder.id3v1).to eql mp3_data
        end
      end

      context "v2" do
        it "creates the id3v2 frame" do
          expect(id3).to receive(:v2)
          encoder.id3v2 { }
        end

        it "yields the vbr frame" do
          mp3_data = double("mp3_data")
          allow(id3).to receive(:v2).and_return(mp3_data)

          expect { |block|
            encoder.id3v2(&block)
          }.to yield_with_args(mp3_data)
        end

        it "returns the vbr frame if no block was given" do
          mp3_data = double("mp3_data")
          allow(id3).to receive(:v2).and_return(mp3_data)
          expect(encoder.id3v2).to eql mp3_data
        end
      end
    end

  end
end
