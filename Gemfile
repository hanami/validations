source 'http://rubygems.org'
gemspec

if !ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri if RUBY_VERSION >= '2.1.0'
  gem 'yard',   require: false
end

gem 'lotus-utils', '~> 0.6', require: false, github: 'lotus/utils', branch: '0.6.x'
gem 'lotus-model', '~> 0.5', require: false, github: 'lotus/model', branch: '0.5.x'
gem 'i18n',        '~> 0.7', require: false
gem 'simplecov',             require: false
gem 'coveralls',             require: false
