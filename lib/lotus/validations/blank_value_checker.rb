module Lotus
  module Validations
    # @since 0.2.2
    # @api private
    class BlankValueChecker
      # @since 0.2.2
      # @api private
      BLANK_STRING_MATCHER = /\A[[:space:]]*\z/.freeze

      def initialize(value)
        @value = value
      end

      # Checks if the value is "blank".
      #
      # @since 0.2.2
      # @api private
      def blank_value?
        _nil_value? || _blank_string? || _empty_value?
      end

      private

      # Checks if the value is `nil`.
      #
      # @since 0.2.2
      # @api private
      def _nil_value?
        @value.nil?
      end

      # @since 0.2.2
      # @api private
      def _blank_string?
        (@value.respond_to?(:match) and @value.match(BLANK_STRING_MATCHER))
      end

      # @since 0.2.2
      # @api private
      def _empty_value?
        (@value.respond_to?(:empty?) and @value.empty?)
      end
    end
  end
end
