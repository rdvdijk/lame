if RUBY_DESCRIPTION =~ /\Aruby 1.9/
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'pry'
require 'lame'

require 'lib/wave_file_generator'
require 'lib/setter_getter'
require 'lib/custom_matchers'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

def pointer_from_string(str)
  ::FFI::MemoryPointer.from_string(str)
end


