# frozen_string_literal: true

source "http://rubygems.org"
gemspec

unless ENV["TRAVIS"]
  gem "byebug", require: false, platforms: :mri
  gem "yard",   require: false
end

gem "hanami-utils", "2.0.0.alpha1", require: false, git: "https://github.com/hanami/utils.git", branch: "unstable"

gem "hanami-devtools", require: false, git: "https://github.com/hanami/devtools.git"
gem "i18n", "~> 0.9",  require: false
gem "coveralls",       require: false
