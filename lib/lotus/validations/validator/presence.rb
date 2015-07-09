module Lotus
  module Validations
    module Validator
      # Build-in custom validator for checking presence
      #
      # @see Lotus::Validations::Validator::Presence
      #
      # @since x.x.x
      class Presence
        include Lotus::Validations::Validator

        BLANK_STRING_MATCHER = /\A[[:space:]]*\z/.freeze

        # Checks if the value is "blank".
        #
        # @since x.x.x
        # @api private
        def valid?
          !(_nil_value? || _blank_string? || _empty_value?)
        end

        # Validator name
        #
        # @since x.x.x
        # @api private
        def validator_name
          :presence
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
          @value.respond_to?(:match) && @value.match(BLANK_STRING_MATCHER)
        end

        # @since x.x.x
        # @api private
        def _empty_value?
          @value.respond_to?(:empty?) && @value.empty?
        end
      end
    end
  end
end
