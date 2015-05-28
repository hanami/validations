module Lotus
  module Validations
    module Validator
      # Mocked class, type symbol is used just for a coercion
      #
      # @see Lotus::Validations::Validator::Type
      #
      # @since x.x.x
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
