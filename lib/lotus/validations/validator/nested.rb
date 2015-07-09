module Lotus
  module Validations
    module Validator
      # Build-in custom validator for nested validators
      #
      # @see Lotus::Validations::Validator::Nested
      #
      # @since x.x.x
      class Nested
        include Lotus::Validations::Validator

        def valid?
          !@value.validate.is_a?(Errors)
        end

        def generate_errors
          @value.errors.instance_variable_get("@errors")
        end

        def validator_name
          :nested
        end
      end
    end
  end
end
