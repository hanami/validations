require 'hanami/validations/context'
require 'hanami/validations/prefix'

module Hanami
  module Validations
    class Rules
      def initialize(key, rules)
        @key   = key
        @rules = rules
      end

      attr_reader :key

      def call(input, output, prefix = nil, predicates = {})
        Context.new(Prefix.join(prefix, @key), input, output, @rules, predicates).call
      end
    end
  end
end
