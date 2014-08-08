require 'lotus/validations/error'

module Lotus
  module Validations
    class Errors
      def initialize
        @hash = Hash.new {|h,k| h[k] = [] }
      end

      def empty?
        @hash.empty?
      end

      def each(&blk)
        @hash.values.flatten.each do |error|
          blk.call(error)
        end
      end

      def map(&blk)
        Array.new.tap do |result|
          self.each {|error| result << blk.call(error) }
        end
      end

      def add(attribute, validation, expected, actual)
        @hash[attribute].push(
          Error.new(attribute, validation, expected, actual)
        )
      end

      def for(attribute)
        @hash[attribute]
      end
    end
  end
end
