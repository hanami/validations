require 'hanami/validations/prefix'

module Hanami
  module Validations
    class Output
      def initialize
        @output ||= ::Hash.new { |h, k| h[k] = {} }
      end

      def update!(key, value)
        h           = @output
        *keys, last = Prefix.split(key)
        keys.each do |k|
          h = h[k]
        end

        h[last] = value
      end

      def to_h
        @output
      end
    end
  end
end
