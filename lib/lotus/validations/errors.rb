require 'lotus/validations/error'

module Lotus
  module Validations
    class Errors
      def initialize
        @errors = Hash.new {|h,k| h[k] = [] }
      end

      def empty?
        @errors.empty?
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
        @errors[attribute].push(
          Error.new(attribute, validation, expected, actual)
        )
      end

      def for(attribute)
        @errors[attribute]
      end

      private
      def errors
        @errors.values.flatten
      end
    end
  end
end
