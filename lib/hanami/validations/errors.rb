module Hanami
  module Validations
    class Errors
      def initialize
        @errors = {}
      end

      def set(key, errors)
        return if errors.empty?
        @errors[key] = errors
      end

      def merge!(errors)
        @errors.merge!(errors.to_h)
      end

      def for(key)
        @errors.fetch(key) { [] }
      end

      def empty?
        @errors.empty?
      end

      def to_h
        @errors
      end
    end
  end
end
