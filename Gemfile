# frozen_string_literal: true

source "http://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", require: false, platforms: :mri
  gem "yard",   require: false
end

gem "hanami-devtools", require: false, git: "https://github.com/hanami/devtools.git"
gem "i18n", "~> 1.0",  require: false
