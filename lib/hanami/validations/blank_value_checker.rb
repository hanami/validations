module Hanami
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
        return false if _enumerable?
        (@value.respond_to?(:empty?) and @value.empty?)
      end

      # Collectable classes should not be considered as blank value
      # even if it's responds _true_ to its own `empty?` method.
      #
      # @since 0.4.0
      # @api private
      def _enumerable?
        @value.respond_to?(:each)
      end
    end
  end
end
