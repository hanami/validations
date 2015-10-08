require 'lotus/utils/string'

module Lotus
  module Validations
    # Validate given validations and return a set of errors
    #
    # @since 0.2.2
    # @api private
    class Validator
      # @param validator [Lotus::Validations] the validator
      #
      # @since 0.2.2
      # @api private
      def initialize(validator)
        @validations    = validator.__send__(:defined_validations)
        @attributes     = validator.__send__(:read_attributes)
        @errors         = validator.errors

        if name = validator.class.name
          @validator_name = Utils::String.new(name).underscore
        end
      end

      # @since 0.2.2
      # @api private
      def validate
        @errors.clear
        @validations.each do |name, validations|
          value = @attributes[name]
          value = @attributes[name.to_s] if value.nil?

          attribute = Attribute.new(@validator_name, @attributes, name, value, validations, @errors)
          attribute.validate
        end
        @errors
      end
    end
  end
end
