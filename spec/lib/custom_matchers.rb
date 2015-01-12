# Validate existence of a getter, setter and the default value.
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

# Validate setting a value.
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

# Validate getting a value.
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

  failure_message do |actual|
    if !has_getter?(actual, expected)
      "expected that #{actual} would have a getter for field :#{expected}"
    elsif @value && !has_value?(actual, expected)
      actual_value = actual_value(actual, expected)
      "expected field :#{expected} to have a value of #{@value}, but got #{actual_value}"
    end
  end
end

# Validate delegation to global_flags.
RSpec::Matchers.define :delegate do |from|
  include SetterGetter

  chain :to do |target|
    @target = target
  end

  match do |subject|
    @from = from
    has_setter?(LAME, target) &&
      delegates_setter? &&
      has_getter?(LAME, target) &&
      delegates_getter?
  end

  def delegates_setter?
    expect(LAME).to receive(:"lame_set_#{target}").with(subject.global_flags, anything)
    subject.send(:"#{from}=", double)
    true
  rescue => e
    # TODO: save raised exception for better failure message
    false
  end

  def delegates_getter?
    expect(LAME).to receive(:"lame_get_#{target}").with(subject.global_flags)
    subject.send(:"#{from}")
    true
  rescue => e
    # TODO: save raised exception for better failure message
    false
  end

  failure_message do |actual|
    "expected #{subject.class} to delegate :#{from} to LAME.lame_set_#{target}"
  end

  def target
    @target || from
  end

  def from
    @from
  end

end

