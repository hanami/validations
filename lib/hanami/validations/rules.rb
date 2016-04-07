require 'hanami/validations/context'

module Hanami
  module Validations
    class Rules
      PREFIX_SEPARATOR = '.'.freeze

      def initialize(key, rules)
        @key   = key
        @rules = rules
      end

      attr_reader :key

      def call(data)
        Context.new(@key, dig(data), @rules).call
      end

      def add_prefix(prefix)
        @key = :"#{ prefix }#{ PREFIX_SEPARATOR }#{ @key }"
        self
      end

      private

      def dig(data)
        key, *keys = @key.to_s.split(PREFIX_SEPARATOR)
        result     = data.fetch(key.to_sym, nil)

        Array(keys).each do |k|
          break if result.nil?
          result = result.fetch(k.to_sym, nil)
        end

        result
      end
    end
  end
end
