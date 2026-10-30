if RUBY_DESCRIPTION =~ /\Aruby 3.4/
  require 'simplecov'
  require 'simplecov-lcov'

  # Configure simplecov-lcov to generate a single lcov.info file
  SimpleCov::Formatter::LcovFormatter.config do |config|
    config.report_with_single_file = true
    config.single_report_path = 'coverage/lcov.info'
  end

  # Set SimpleCov to use the LCOV formatter
  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter

  SimpleCov.start do "test"
    add_filter '/spec/' # Exclude spec files from coverage statistics
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


