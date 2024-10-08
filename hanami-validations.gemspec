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
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "dry-validation", ">= 1.10", "< 2"

  spec.add_development_dependency "bundler", ">= 1.6", "< 3"
  spec.add_development_dependency "rake",    "~> 13"
  spec.add_development_dependency "rspec",   "~> 3.9"
  spec.add_development_dependency "rubocop", "~> 1.0"
end
