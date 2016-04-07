require 'rubygems'
require 'bundler/setup'

if ENV['COVERALL']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
$LOAD_PATH.unshift 'lib'
require 'hanami/validations'
require 'bigdecimal'

require 'uri'
require 'hanami/utils/blank'

class Url
  def initialize(url)
    raise ArgumentError if Hanami::Utils::Blank.blank?(url)
    @url = URI.parse(url.to_s)
  end

  def to_str
    @url.to_s
  end
end

class FullName
  attr_reader :tokens
  def initialize(*tokens)
    @tokens = tokens
  end

  def to_s
    @tokens.join ' '
  end
end
