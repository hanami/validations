require 'hanami/validations/context'

module Hanami
  module Validations
    class Rules
      def initialize(key, rules)
        @key   = key
        @rules = rules
      end

      attr_reader :key

      def call(data)
        Context.new(@key, data, @rules).call
      end

      def add_prefix(prefix)
        @key = :"#{ prefix }#{ Context::PREFIX_SEPARATOR }#{ @key }"
        self
      end
    end
  end
end
