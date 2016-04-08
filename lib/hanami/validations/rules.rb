require 'hanami/validations/context'

module Hanami
  module Validations
    class Rules
      def initialize(key, rules)
        @key   = key
        @rules = rules
      end

      attr_reader :key

      def call(data, prefix = nil, predicates = {})
        Context.new(_prefixed_key(prefix), data, @rules, predicates).call
      end

      protected

      def _prefixed_key(prefix)
        [prefix, @key].compact.join('.').to_sym
      end
    end
  end
end
