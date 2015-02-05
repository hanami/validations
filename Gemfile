source 'http://rubygems.org'
gemspec

if !ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri if RUBY_VERSION >= '2.1.0'
  gem 'yard',   require: false
end

gem 'lotus-utils', require: false, github: 'lotus/utils', branch: '0.4.x'
gem 'lotus-model', require: false, github: 'lotus/model', branch: '0.3.x'
gem 'simplecov',   require: false
gem 'coveralls',   require: false

group :development do
  gem 'pry', require: false
end
