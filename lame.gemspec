# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lame/version'

Gem::Specification.new do |gem|
  gem.name          = "lame"
  gem.version       = LAME::VERSION
  gem.authors       = ["Roel van Dijk"]
  gem.email         = ["roel@rustradio.org"]
  gem.description   = %q{FFI powered library for the LAME MP3 encoder.}
  gem.summary       = %q{Easily encode MP3 files using the LAME MP3 encoder.}
  gem.homepage      = "http://github.com/rdvdijk/lame"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "ffi"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
end
