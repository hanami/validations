module Lotus
  module Validations
    module Validator
      class With
        include Lotus::Validations::Validator

        def valid?
          @validator_value.call(@attributes, @name, @validator_value)
        end

        def validator_name
          :size
        end
      end
    end
  end
end
