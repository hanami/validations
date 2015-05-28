module Lotus
  module Validations
    module Validator
      # Build-in custom validator for accepting boolean values
      #
      # @see Lotus::Validations::Validator::Acceptance
      #
      # @since x.x.x
      class Acceptance
        include Lotus::Validations::Validator

        def valid?
          Lotus::Utils::Kernel.Boolean(@value)
        end

        def validator_name
          :acceptance
        end
      end
    end
  end
end
