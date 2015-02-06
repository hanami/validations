module Lotus
  module Validations
    module Validator
      class Type
        include Lotus::Validations::Validator

        def valid?
          true
        end

        def validator_name
          :type
        end
      end
    end
  end
end
