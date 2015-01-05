module Lotus
  module Validations
    # @since x.x.x
    # @api private
    class BlankValueChecker
      # @since x.x.x
      # @api private
      BLANK_STRING_MATCHER = /\A[[:space:]]*\z/.freeze

      def initialize(value)
        @value = value
      end

      # Checks if the value is "blank".
      #
      # @since x.x.x
      # @api private
      def blank_value?
        _nil_value? || _blank_string? || _empty_value?
      end

      private

      # Checks if the value is `nil`.
      #
      # @since x.x.x
      # @api private
      def _nil_value?
        @value.nil?
      end

      # @since x.x.x
      # @api private
      def _blank_string?
        (@value.respond_to?(:match) and @value.match(BLANK_STRING_MATCHER))
      end

      # @since x.x.x
      # @api private
      def _empty_value?
        (@value.respond_to?(:empty?) and @value.empty?)
      end
    end
  end
end
