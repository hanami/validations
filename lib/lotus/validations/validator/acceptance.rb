module Lotus
  module Validations
    module Validator
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
