# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hanami/validations/version"

Gem::Specification.new do |spec|
  spec.name          = "hanami-validations"
  spec.version       = Hanami::Validations::VERSION
  spec.authors       = ["Luca Guidi"]
  spec.email         = ["me@lucaguidi.com"]
  spec.summary       = "Validations mixin for Ruby objects"
  spec.description   = "Validations mixin for Ruby objects and support for Hanami"
  spec.homepage      = "http://hanamirb.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files -- lib/* LICENSE.md README.md CHANGELOG.md hanami-validations.gemspec`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.3.0"

  spec.add_dependency "hanami-utils",     "~> 1.3"
  spec.add_dependency "dry-validation",   "~> 0.11", "< 0.12"
  spec.add_dependency "dry-logic",        "~> 0.4.2", "< 0.5"
  spec.add_dependency "dry-configurable", "<= 0.12"

  spec.add_development_dependency "bundler", ">= 1.6", "< 3"
  spec.add_development_dependency "rake",    "~> 13"
  spec.add_development_dependency "rspec",   "~> 3.9"
  spec.add_development_dependency "rubocop", "0.81" # rubocop 0.81+ removed support for Ruby 2.3
end
