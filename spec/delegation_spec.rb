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

    let(:global_flags) { double("global_flags") }
    subject { FakeEncoder.new }

    before do
      subject.global_flags = global_flags
    end

    context "#delegate_alias_to_lame" do
      it "delegates #foo= to LAME" do
        expect(LAME).to receive(:lame_set_bar).with(global_flags, anything)
        subject.foo = double("delegate")
      end

      it "delegates #foo to LAME" do
        expect(LAME).to receive(:lame_get_bar).with(global_flags)
        subject.foo
      end

      it "delegates #foo? to LAME" do
        expect(LAME).to receive(:lame_get_bar).with(global_flags)
        subject.foo?
      end
    end

    context "#delegate_to_lame" do
      it "delegates #baz= to LAME" do
        expect(LAME).to receive(:lame_set_baz).with(global_flags, anything)
        subject.baz = double("delegate")
      end

      it "delegates #baz to LAME" do
        expect(LAME).to receive(:lame_get_baz).with(global_flags)
        subject.baz
      end

      it "delegates #baz? to LAME" do
        expect(LAME).to receive(:lame_get_baz).with(global_flags)
        subject.baz?
      end
    end

    context "#delegate_id3_to_lame" do
      it "delegates #qux= to LAME" do
        expect(LAME).to receive(:id3tag_set_qux).with(global_flags, anything)
        subject.qux = double("delegate")
      end
    end

    context "type conversion" do
      it "converts the input type" do
        value = double("value")
        expect(Delegation::TypeConvertor).to receive(:convert).with(value)
        allow(LAME).to receive(:lame_set_baz)
        subject.baz = value
      end

      it "passes on converted value to setter" do
        value = double("value")
        converted_value = double("converted_value")
        allow(Delegation::TypeConvertor).to receive(:convert).and_return(converted_value)
        expect(LAME).to receive(:lame_set_baz).with(global_flags, converted_value)
        subject.baz = value
      end

      it "converts question mark style getters to return booleans" do
        allow(LAME).to receive(:lame_get_baz).and_return(0)
        expect(Delegation::TypeConvertor).to receive(:convert_return).with(0)
        subject.baz?
      end

      it "converts question mark style getters to return booleans" do
        allow(LAME).to receive(:lame_get_baz)
        allow(Delegation::TypeConvertor).to receive(:convert_return).and_return(false)
        expect(subject.baz?).to be_falsy
      end
    end

  end

  describe Delegation::TypeConvertor do

    subject(:converter) { Delegation::TypeConvertor }

    describe "#convert" do
      it "converts true to 1" do
        expect(converter.convert(true)).to eql 1
      end

      it "converts false to 0" do
        expect(converter.convert(false)).to eql 0
      end

      it "converts a string to a pointer with correct value" do
        input = "some string"
        value = converter.convert(input)
        expect(value).to be_a(::FFI::MemoryPointer)
        expect(value.get_string(0)).to eql input
      end

      it "does not convert other values" do
        expect(converter.convert(:foo)).to eql :foo
        expect(converter.convert(1.2)).to eql 1.2
      end
    end

    describe "#convert_return" do
      it "converts 1 to true" do
        expect(converter.convert_return(1)).to eql true
      end

      it "converts 0 to false" do
        expect(converter.convert_return(0)).to eql false
      end

      it "converts 0.0 to false" do
        expect(converter.convert_return(0.0)).to eql false
      end

      it "returns truthy to true" do
        expect(converter.convert_return(:truthy)).to eql true
        expect(converter.convert_return("truthy")).to eql true
        expect(converter.convert_return(Object)).to eql true
        expect(converter.convert_return(Object.new)).to eql true
        expect(converter.convert_return(4.2)).to eql true
      end
    end

  end

end
