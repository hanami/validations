module Lotus
  module Validations
    class BlankValueChecker
      # @since 0.2.0
      # @api private
      BLANK_STRING_MATCHER = /\A[[:space:]]*\z/.freeze

      def initialize(value)
        @value = value
      end

      # Checks if the value is "blank".
      #
      # @since 0.2.0
      # @api private
      def blank_value?
        nil_value? || _blank_string? || _empty_value?
      end

      private

      # Checks if the value is `nil`.
      #
      # @since 0.2.0
      # @api private
      def nil_value?
        @value.nil?
      end

      # @since 0.2.0
      # @api private
      def _blank_string?
        (@value.respond_to?(:match) and @value.match(BLANK_STRING_MATCHER))
      end

      # @since 0.2.0
      # @api private
      def _empty_value?
        (@value.respond_to?(:empty?) and @value.empty?)
      end
    end
  end
end