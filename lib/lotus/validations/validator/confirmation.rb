module Lotus
  module Validations
    module Validator
      # Build-in custom validator for checking confirmation
      #
      # @see Lotus::Validations::Validator::Confirmation
      #
      # @since x.x.x
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
