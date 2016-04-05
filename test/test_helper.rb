require 'rubygems'
require 'bundler/setup'

if ENV['COVERALL']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
$LOAD_PATH.unshift 'lib'
require 'hanami/validations'
require 'hanami/validations/form'

class Input
  attr_reader :foo

  def initialize(foo)
    @foo = foo
  end
end
