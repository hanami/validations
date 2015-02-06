module Lotus
  module Validations
    module Validator
      class Confirmation
        include Lotus::Validations::Validator

        def valid?
          @value == @attributes["#{@name}_confirmation".to_sym]
        end

        def validator_name
          :confirmation
        end
      end
    end
  end
end
