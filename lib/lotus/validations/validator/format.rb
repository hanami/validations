module Lotus
  module Validations
    module Validator
      # Build-in custom validator for checking specific match
      #
      # @see Lotus::Validations::Validator::Format
      #
      # @since x.x.x
      class Format
        include Lotus::Validations::Validator

        def valid?
          return true if @value.nil?

          @value.to_s.match(@validator_value)
        end

        def validator_name
          :format
        end
      end
    end
  end
end
