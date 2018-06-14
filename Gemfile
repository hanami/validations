# frozen_string_literal: true

source "http://rubygems.org"
gemspec

unless ENV["TRAVIS"]
  gem "byebug", require: false, platforms: :mri
  gem "yard",   require: false
end

gem "dry-validation", git: "https://github.com/dry-rb/dry-validation.git"
gem "dry-types",      git: "https://github.com/dry-rb/dry-types.git"
gem "hanami-utils", "~> 2.0.alpha", require: false, git: "https://github.com/hanami/utils.git", branch: "feature/result"

gem "hanami-devtools", require: false, git: "https://github.com/hanami/devtools.git"
gem "i18n", "~> 1.0",  require: false
gem "coveralls",       require: false
