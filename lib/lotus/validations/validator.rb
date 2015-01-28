module Lotus
  module Validations
    # Validate given validations and return a set of errors
    #
    # @since 0.2.2
    # @api private
    class Validator
      def initialize(validation_set, attributes, errors)
        @validation_set = validation_set
        @attributes = attributes
        @errors = errors
      end

      # @since 0.2.2
      # @api private
      def validate
        @errors.clear
        @validation_set.each do |name, validations|
          value = @attributes[name]
          value = @attributes[name.to_s] if value.nil?

          attribute = Attribute.new(@attributes, name, value, validations, @errors)
          attribute.validate
        end
        @errors
      end
    end
  end
end
