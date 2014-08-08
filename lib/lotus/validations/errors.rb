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

      def count
        errors.count
      end

      alias_method :size, :count

      def each(&blk)
        errors.each do |error|
          blk.call(error)
        end
      end

      def map(&blk)
        errors.map do |error|
          blk.call(error)
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

      private
      def errors
        @hash.values.flatten
      end
    end
  end
end
