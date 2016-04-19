require 'hanami/validations/error'
require 'delegate'
require 'set'

module Hanami
  module Validations
    class KeyErrors < SimpleDelegator
      def initialize(key)
        super(Set.new)
        @key = key
      end

      def check_result!(result)
        if empty? && (result == false || result.nil?)
          add(:base, nil, result)
        end
      end

      def add(predicate, expected, actual)
        __getobj__.add Error.new(@key, predicate, expected, actual)
      end
    end
  end
end
