require 'rubygems'
require 'bundler/setup'

if ENV['COVERALL']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
require_relative './support/test_utils'
require_relative './support/assertions'

$LOAD_PATH.unshift 'lib'
require 'hanami/validations'
require 'hanami/validations/form'
