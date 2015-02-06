module Lotus
  module Validations
    module Validator
      class Presence
        include Lotus::Validations::Validator

        BLANK_STRING_MATCHER = /\A[[:space:]]*\z/.freeze

        # Checks if the value is "blank".
        #
        # @since 0.2.2
        # @api private
        def valid?
          !(_nil_value? || _blank_string? || _empty_value?)
        end

        def validator_name
          :presence
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
          @value.respond_to?(:match) && @value.match(BLANK_STRING_MATCHER)
        end

        # @since 0.2.2
        # @api private
        def _empty_value?
          @value.respond_to?(:empty?) && @value.empty?
        end


      end
    end
  end
end
