source 'http://rubygems.org'
gemspec

unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'hanami-utils', '~> 0.8',  require: false, github: 'hanami/utils', branch: '0.8.x'
gem 'hanami-model', '~> 0.7',  require: false, github: 'hanami/model', branch: '0.7.x'
gem 'i18n',         '~> 0.7',  require: false
gem 'rubocop',      '~> 0.41', require: false
gem 'coveralls',               require: false

gem 'dry-validation', github: 'dry-rb/dry-validation', branch: 'master'
gem 'dry-types', github: 'dry-rb/dry-types', branch: 'master'
gem 'dry-struct', github: 'dry-rb/dry-struct', branch: 'master'
gem 'dry-logic', github: 'dry-rb/dry-logic', branch: 'master'
