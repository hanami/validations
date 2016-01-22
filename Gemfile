source 'http://rubygems.org'
gemspec

if !ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri if RUBY_VERSION >= '2.2.0'
  gem 'yard',   require: false
end

gem 'hanami-utils', '~> 0.7', require: false, github: 'hanami/utils', branch: '0.7.x'
# gem 'hanami-model', '~> 0.6', require: false, github: 'hanami/model', branch: '0.6.x'
gem 'simplecov',              require: false
gem 'coveralls',              require: false
