require 'hanami/validations/prefix'

module Hanami
  module Validations
    class Input
      def initialize(input = {})
        @input = input
      end

      def value(key)
        key, *keys = Prefix.split(key)
        result     = fetch(key)

        ::Kernel.Array(keys).each do |k|
          break if result.nil?
          result = fetch(k, result)
        end

        result
      end

      protected

      def fetch(key, input = @input)
        input.fetch(key) do
          input.fetch(key.to_s, nil)
        end
      end
    end
  end
end
