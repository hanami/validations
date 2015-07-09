module Lotus
  module Validations
    module Validator
      # Build-in custom validator for checking size
      #
      # @see Lotus::Validations::Validator::Size
      #
      # @since x.x.x
      class Size
        include Lotus::Validations::Validator

        def valid?
          return true unless @value.respond_to?(:size)

          case @validator_value
          when Numeric, ->(v) { v.respond_to?(:to_int) }
            @value.size == @validator_value.to_int
          when Range
            @validator_value.include?(@value.size)
          else
            raise ArgumentError.new("Size validator must be a number or a range, it was: #{ @validator_value }")
          end
        end

        def validator_name
          :size
        end
      end
    end
  end
end
