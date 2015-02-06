module Lotus
  module Validations
    module Validator
      class Inclusion
        include Lotus::Validations::Validator

        def valid?
          return true if @value.nil?

          @validator_value.include?(@value)
        end

        def validator_name
          :inclusion
        end
      end
    end
  end
end
