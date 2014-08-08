module Lotus
  module Validations
    class Errors
      def initialize
        @hash = Hash.new {|h,k| h[k] = {} }
      end

      def empty?
        @hash.empty?
      end

      def each(&blk)
        @hash.each do |attribute, errors|
          errors.each do |validation, (expected, actual)|
            blk.call attribute, validation, expected, actual
          end
        end
      end

      def map(&blk)
        Array.new.tap do |result|
          self.each {|*args| result << blk.call(*args) }
        end
      end

      def add(attribute, validation, expected, actual)
        @hash[attribute].merge!(validation => [expected, actual])
      end

      def for(attribute)
        @hash[attribute]
      end
    end
  end
end
