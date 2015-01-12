module LAME

  describe DecodeFlags do 
    it "initializes LAME" do
      pointer = ::FFI::Pointer.new(0)
      expect(LAME).to receive(:hip_decode_init).and_return(pointer)
      DecodeFlags.new
    end

    it "closes the LAME struct pointer" do
      pointer = ::FFI::Pointer.new(0)
      expect(LAME).to receive(:hip_decode_exit).with(pointer)
      DecodeFlags.release(pointer)
    end
  end

end
