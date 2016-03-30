require 'rubygems'
require 'bundler/setup'

if ENV['COVERALL']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
$:.unshift 'lib'
require 'hanami/validations'

module Hanami::Validations::ValidationIntrospection
  def defined_validation?(name)
    validations.instance_variable_get(:@validations).keys.include?(name)
  end
end

require 'fixtures'
require 'messages/fixtures'
