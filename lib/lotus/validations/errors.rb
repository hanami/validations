module Lotus
  module Validations
    class Errors
      def initialize
        @hash = Hash.new {|h,k| h[k] = {} }
      end

      def empty?
        @hash.empty?
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
