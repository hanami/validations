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
    validations.names.include?(name)
  end

  def validation_index(attribute_name, validation_name)
    validations.instance_variable_get(:@validations).index do |validation|
      validation.attribute_name == attribute_name &&
        validation.validation_name == validation_name
    end
  end
end

require 'fixtures'
