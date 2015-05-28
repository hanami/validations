module Lotus
  module Validations
    module Validator
      # Build-in custom validator for checking exclusion
      #
      # @see Lotus::Validations::Validator::Exclusion
      #
      # @since x.x.x
      class Exclusion
        include Lotus::Validations::Validator

        def valid?
          return true if @value.nil?

          !@validator_value.include?(@value)
        end

        def validator_name
          :exclusion
        end
      end
    end
  end
end
