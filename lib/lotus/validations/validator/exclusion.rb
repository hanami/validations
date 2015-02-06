module Lotus
  module Validations
    module Validator
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
