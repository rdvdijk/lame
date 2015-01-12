require 'spec_helper'

module LAME
  describe "FFI calls to id3tag setters" do

    before do
      @flags_pointer = LAME.lame_init
    end

    after do
      LAME.lame_close(@flags_pointer)
    end

    it "has all the genres" do
      genres = {}

      genre_collector_callback = ::FFI::Function.new(:void, [:int, :string, :pointer]) do |id, name, _|
        genres[id] = name
      end

      LAME.id3tag_genre_list(genre_collector_callback, nil)

      expect(genres.length).to be(148)
      expect(genres[0]).to eql "Blues"
      expect(genres[147]).to eql "SynthPop"
    end

    it "initializes" do
      expect(LAME.id3tag_init(@flags_pointer)).to eql nil
    end

    it "adds v2" do
      expect(LAME.id3tag_add_v2(@flags_pointer)).to eql nil
    end

    it "set v1 only" do
      expect(LAME.id3tag_v1_only(@flags_pointer)).to eql nil
    end

    it "set v2 only" do
      expect(LAME.id3tag_v2_only(@flags_pointer)).to eql nil
    end

    it "pads with spaces" do
      expect(LAME.id3tag_space_v1(@flags_pointer)).to eql nil
    end

    it "pads v2 with 128 extra bytes" do
      expect(LAME.id3tag_pad_v2(@flags_pointer)).to eql nil
    end

    it "pads v2 with extra bytes" do
      expect(LAME.id3tag_set_pad(@flags_pointer, 256)).to eql nil
    end

    it "sets the title" do
      expect(LAME.id3tag_set_title(@flags_pointer, pointer_from_string("foo"))).to eql nil
    end

    it "sets the artist" do
      expect(LAME.id3tag_set_artist(@flags_pointer, pointer_from_string("foo"))).to eql nil
    end

    it "sets the album" do
      expect(LAME.id3tag_set_album(@flags_pointer, pointer_from_string("foo"))).to eql nil
    end

    it "sets the year" do
      expect(LAME.id3tag_set_year(@flags_pointer, pointer_from_string("foo"))).to eql nil
    end

    it "sets the comment" do
      expect(LAME.id3tag_set_comment(@flags_pointer, pointer_from_string("foo"))).to eql nil
    end

    it "sets the track" do
      expect(LAME.id3tag_set_track(@flags_pointer, pointer_from_string("1"))).to eql 0
    end

    it "ignores out of range track numbers for id3" do
      expect(LAME.id3tag_set_track(@flags_pointer, pointer_from_string("256"))).to eql -1
    end

    it "sets the genre" do
      expect(LAME.id3tag_set_genre(@flags_pointer, pointer_from_string("Rock"))).to eql 0
    end

    # There is a fixed set of allowed fields (see id3tag.c)
    # LAME 3.99.4 fixed some bugs in setting field values, this could crash for certain tags.
    it "sets the fieldvalue" do
      expect(LAME.id3tag_set_fieldvalue(@flags_pointer, pointer_from_string("TIT2=foofoo"))).to eql 0
    end

    # it "sets the fieldvalue (utf16)" do
    #   LAME.id3tag_set_fieldvalue_utf16(@flags_pointer, "LINK=foofoo".encode("UTF-16")).should eql 0
    # end

    it "sets album art" do
      buffer_size = 1024

      # fake JPG image
      buffer = ::FFI::MemoryPointer.new(:char, buffer_size)
      buffer.put_char(0, 0xff)
      buffer.put_char(1, 0xd8)

      expect(LAME.id3tag_set_albumart(@flags_pointer, buffer, buffer_size)).to eql 0
    end

    it "creates id3v1 tag" do
      buffer_size = 1024
      buffer = ::FFI::MemoryPointer.new(:uchar, buffer_size)
      LAME.id3tag_set_title(@flags_pointer, pointer_from_string("foo"))
      LAME.id3tag_set_album(@flags_pointer, pointer_from_string("bar"))
      expect(LAME.lame_get_id3v1_tag(@flags_pointer, buffer, buffer_size)).to eql 128
    end

    it "creates id3v2 tag" do
      buffer_size = 1024
      buffer = ::FFI::MemoryPointer.new(:uchar, buffer_size)
      LAME.id3tag_add_v2(@flags_pointer)
      LAME.id3tag_set_title(@flags_pointer, pointer_from_string("foo"))
      LAME.id3tag_set_album(@flags_pointer, pointer_from_string("bar"))
      expect(LAME.lame_get_id3v2_tag(@flags_pointer, buffer, buffer_size)).to eql 38
    end

    it "sets id3tag automatic" do
      expect(LAME).to have_flag(:write_id3tag_automatic).with_value(1).for(@flags_pointer)
    end

    it "gets id3tag automatic" do
      expect(LAME).to be_able_to_set(:write_id3tag_automatic).to(0).for(@flags_pointer).and_return(nil)
    end

  end
end
