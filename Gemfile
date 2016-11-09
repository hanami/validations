source 'http://rubygems.org'
gemspec

unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'dry-struct',     require: false, github: 'dry-rb/dry-struct'     # FIXME: this is needed until they will release 0.1
gem 'dry-types',      require: false, github: 'dry-rb/dry-types'      # FIXME: this is needed until they will release 0.9
gem 'dry-validation', require: false, github: 'dry-rb/dry-validation' # FIXME: this is needed until they will release 0.10

gem 'hanami-utils', '~> 0.8',  require: false, github: 'hanami/utils', branch: '0.8.x'
gem 'hanami-model', '~> 0.7',  require: false, github: 'hanami/model', branch: '0.7.x'
gem 'i18n',         '~> 0.7',  require: false
gem 'rubocop',      '~> 0.45', require: false
gem 'coveralls',               require: false
