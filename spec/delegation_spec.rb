require 'spec_helper'

module LAME

  class FakeEncoder
    extend Delegation

    attr_accessor :global_flags

    delegate_alias_to_lame :foo => :bar
    delegate_to_lame :baz
    delegate_id3_to_lame :qux
  end

  describe Delegation do

    let(:global_flags) { stub }
    subject { FakeEncoder.new }

    before do
      subject.global_flags = global_flags
    end

    context "#delegate_alias_to_lame" do
      it "delegates #foo= to LAME" do
        LAME.should_receive(:lame_set_bar).with(global_flags, anything)
        subject.foo = stub
      end

      it "delegates #foo to LAME" do
        LAME.should_receive(:lame_get_bar).with(global_flags)
        subject.foo
      end
    end

    context "#delegate_to_lame" do
      it "delegates #baz= to LAME" do
        LAME.should_receive(:lame_set_baz).with(global_flags, anything)
        subject.baz = stub
      end

      it "delegates #baz to LAME" do
        LAME.should_receive(:lame_get_baz).with(global_flags)
        subject.baz
      end
    end

    context "#delegate_id3_to_lame" do
      it "delegates #qux= to LAME" do
        LAME.should_receive(:id3tag_set_qux).with(global_flags, anything)
        subject.qux = stub
      end
    end

    context "type conversion" do
      it "converts the input type" do
        value = stub
        Delegation::TypeConvertor.should_receive(:convert).with(value)
        LAME.stub(:lame_set_baz)
        subject.baz = value
      end

      it "passes on converted value to setter" do
        value = stub
        converted_value = stub
        Delegation::TypeConvertor.stub(:convert).and_return(converted_value)
        LAME.should_receive(:lame_set_baz).with(global_flags, converted_value)
        subject.baz = value
      end
    end

  end

  describe Delegation::TypeConvertor do

    subject(:converter) { Delegation::TypeConvertor }

    it "converts true to 1" do
      converter.convert(true).should eql 1
    end

    it "converts false to 0" do
      converter.convert(true).should eql 1
    end

    it "converts a string to a pointer with correct value" do
      input = "some string"
      value = converter.convert(input)
      value.should be_a(::FFI::MemoryPointer)
      value.get_string(0).should eql input
    end

    it "does not convert other values" do
      converter.convert(:foo).should eql :foo
      converter.convert(1.2).should eql 1.2
    end

  end

end
