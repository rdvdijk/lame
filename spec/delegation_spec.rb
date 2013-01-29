require 'spec_helper'

module LAME

  class FakeEncoder
    extend Delegation

    attr_accessor :global_flags

    delegate_alias_to_lame :foo => :bar
    delegate_to_lame :baz
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

  end
end
