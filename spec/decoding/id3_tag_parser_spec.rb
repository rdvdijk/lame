require 'spec_helper'

module LAME
  module Decoding
    describe Id3TagParser do

      let(:stream) { StringIO.new(stream_string) }
      let(:parser) { Id3TagParser.new(stream) }

      describe "#skip!" do

        context "valid header" do
          let(:stream_string) do
            header = "ID3   "
            header << 0b00000000
            header << 0b00000000
            header << 0b00000010
            header << 0b01010101
            header << " "*341 # the above bits are '341'
          end

          it "seeks the file until after the id3 tag" do
            parser.skip!
            expect(stream.pos).to eql 351
          end

          it "start from the start of the stream" do
            stream.seek(42)
            parser.skip!
            expect(stream.pos).to eql 351
          end
        end


        context "no id3 tag" do
          let(:stream_string) { " "*1024 }

          it "does not crash if id3 tag is not present" do
            expect {
              parser.skip!
            }.not_to raise_error
          end

          it "does not seek the stream if no header is present" do
            parser.skip!
            expect(stream.pos).to eql 0
          end
        end

      end

    end
  end
end
