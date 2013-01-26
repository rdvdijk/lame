require 'lame'
require 'pry'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

def pointer_from_string(str)
  ::FFI::MemoryPointer.from_string(str)
end

module SetterGetter
  def has_getter?(lame, flag)
    lame.respond_to?(:"lame_get_#{flag}")
  end

  def has_setter?(lame, flag)
    lame.respond_to?(:"lame_set_#{flag}")
  end

  def set_value(lame, flag)
    lame.send(:"lame_set_#{flag}", @flags_pointer, @value) == return_value
  end

  def return_value
    defined?(@return) ? @return : 0
  end

  def has_value?(lame, flag)
    if @value.is_a?(Float)
      actual = lame.send(:"lame_get_#{flag}", @flags_pointer)
      (actual - @value).abs < 0.0001
    elsif @value
      lame.send(:"lame_get_#{flag}", @flags_pointer) == @value
    else
      true
    end
  end
end

RSpec::Matchers.define :have_flag do |expected|
  include SetterGetter

  chain :for do |flags_pointer|
    @flags_pointer = flags_pointer
  end

  chain :with_value do |value|
    @value = value
  end

  match do |actual|
    has_getter?(actual, expected) &&
      has_setter?(actual, expected) &&
      has_value?(actual, expected)
  end
end

RSpec::Matchers.define :be_able_to_set do |expected|
  include SetterGetter

  chain :for do |flags_pointer|
    @flags_pointer = flags_pointer
  end

  chain :to do |value|
    @value = value
  end

  chain :and_return do |value|
    @return = value
  end

  match do |actual|
    set_value(actual, expected) &&
      has_value?(actual, expected)
  end
end

RSpec::Matchers.define :have_getter do |expected|
  include SetterGetter

  chain :for do |flags_pointer|
    @flags_pointer = flags_pointer
  end

  chain :with_value do |value|
    @value = value
  end

  match do |actual|
    has_getter?(actual, expected) &&
      has_value?(actual, expected)
  end
end
