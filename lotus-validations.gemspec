# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lotus/validations/version'

Gem::Specification.new do |spec|
  spec.name          = 'lotus-validations'
  spec.version       = Lotus::Validations::VERSION
  spec.authors       = ['Luca Guidi', 'Trung Lê']
  spec.email         = ['me@lucaguidi.com', 'trung.le@ruby-journal.com']
  spec.summary       = %q{Validations mixin for Ruby objects}
  spec.description   = %q{Validations mixin for Ruby objects and support for Lotus}
  spec.homepage      = 'http://lotusrb.org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -- lib/* LICENSE.md README.md CHANGELOG.md lotus-validations.gemspec`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'lotus-utils', '~> 0.4'

  spec.add_development_dependency 'bundler',  '~> 1.6'
  spec.add_development_dependency 'minitest', '~> 5'
  spec.add_development_dependency 'rake',     '~> 10'
end
