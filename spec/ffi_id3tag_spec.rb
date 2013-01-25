require 'spec_helper'
require 'pry'

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

      genre_collector_callback = FFI::Function.new(:void, [:int, :string, :pointer]) do |id, name, _|
        genres[id] = name
      end

      LAME.id3tag_genre_list(genre_collector_callback, nil)

      genres.should have(148).items
      genres[0].should eql "Blues"
      genres[147].should eql "SynthPop"
    end

    it "initializes" do
      LAME.id3tag_init(@flags_pointer).should eql nil
    end

    it "adds v2" do
      LAME.id3tag_add_v2(@flags_pointer).should eql nil
    end

    it "set v1 only" do
      LAME.id3tag_v1_only(@flags_pointer).should eql nil
    end

    it "set v2 only" do
      LAME.id3tag_v2_only(@flags_pointer).should eql nil
    end

    it "pads with spaces" do
      LAME.id3tag_space_v1(@flags_pointer).should eql nil
    end

    it "pads v2 with 128 extra bytes" do
      LAME.id3tag_pad_v2(@flags_pointer).should eql nil
    end

    it "pads v2 with extra bytes" do
      LAME.id3tag_set_pad(@flags_pointer, 256).should eql nil
    end

    it "sets the title" do
      LAME.id3tag_set_title(@flags_pointer, "foo").should eql nil
    end

    it "sets the artist" do
      LAME.id3tag_set_artist(@flags_pointer, "foo").should eql nil
    end

    it "sets the album" do
      LAME.id3tag_set_album(@flags_pointer, "foo").should eql nil
    end

    it "sets the year" do
      LAME.id3tag_set_year(@flags_pointer, "foo").should eql nil
    end

    it "sets the comment" do
      LAME.id3tag_set_comment(@flags_pointer, "foo").should eql nil
    end

    # TODO out of range
    it "sets the track" do
      LAME.id3tag_set_track(@flags_pointer, "1").should eql 0
    end

    # TODO all genre id's, genre names, id3v1 ignores custom
    it "sets the genre" do
      LAME.id3tag_set_genre(@flags_pointer, "Rock").should eql 0
    end

    # fixed set of allowed fields (see id3tag.c)
    it "sets the fieldvalue" do
      LAME.id3tag_set_fieldvalue(@flags_pointer, "USER=foofoo").should eql 0 # huh?
    end

    it "sets album art" do
      buffer_size = 1024

      # fake JPG image
      buffer = FFI::MemoryPointer.new(:char, buffer_size)
      buffer.put_char(0, 0xff)
      buffer.put_char(1, 0xd8)

      LAME.id3tag_set_albumart(@flags_pointer, buffer, buffer_size).should eql 0
    end

    it "creates id3v1 tag" do
      buffer_size = 1024
      buffer = FFI::MemoryPointer.new(:uchar, buffer_size)
      LAME.id3tag_set_title(@flags_pointer, "foo")
      LAME.id3tag_set_album(@flags_pointer, "bar")
      LAME.lame_get_id3v1_tag(@flags_pointer, buffer, buffer_size).should eql 128
    end

    it "creates id3v2 tag" do
      buffer_size = 1024
      buffer = FFI::MemoryPointer.new(:uchar, buffer_size)
      LAME.id3tag_add_v2(@flags_pointer)
      LAME.id3tag_set_title(@flags_pointer, "foo")
      LAME.id3tag_set_album(@flags_pointer, "bar")
      LAME.lame_get_id3v2_tag(@flags_pointer, buffer, buffer_size).should eql 38
    end

    it "sets id3tag automatic" do
      LAME.should have_flag(:write_id3tag_automatic).with_value(1).for(@flags_pointer)
    end

    it "gets id3tag automatic" do
      LAME.should be_able_to_set(:write_id3tag_automatic).to(0).for(@flags_pointer).and_return(nil)
    end

  end
end
