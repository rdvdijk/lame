require 'spec_helper'

module LAME

  class FakeEncoder
    extend Delegation

    attr_accessor :global_flags

    delegate_to_lame :foo => :bar
  end

  describe Delegation do

    let(:global_flags) { stub }
    subject { FakeEncoder.new }

    before do
      subject.global_flags = global_flags
    end

    it "delegates #foo= to LAME" do
      LAME.should_receive(:lame_set_bar).with(global_flags, 42)
      subject.foo = 42
    end

    it "delegates #foo to LAME" do
      LAME.should_receive(:lame_get_bar).with(global_flags)
      subject.foo
    end

  end
end
