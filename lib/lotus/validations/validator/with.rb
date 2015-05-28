module Lotus
  module Validations
    module Validator
      # Build-in custom validator making possible to use custom validators
      #
      # @see Lotus::Validations::Validator::With
      #
      # @since x.x.x
      class With
        include Lotus::Validations::Validator

        def valid?
          @validator_value.call(@attributes, @name, @validator_value)
        end

        def validator_name
          :with
        end
      end
    end
  end
end
