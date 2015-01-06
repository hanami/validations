module Lotus
  module Validations
    # Validate given validations and return a set of errors
    #
    # @since 0.2.2
    # @api private
    class Validator
      def initialize(validation_set, attributes)
        @validation_set = validation_set
        @attributes = attributes
      end

      # @since 0.2.2
      # @api private
      def validate
        Errors.new.tap do |errors|
          @validation_set.each do |name, validations|
            value = @attributes[name]
            value = @attributes[name.to_s] if value.nil?

            if value.respond_to?(:validate)
              errors.add_nested name, value.validate
            else
              attribute = Attribute.new(@attributes, name, value, validations)
              errors.add name, *attribute.validate
            end
          end
        end
      end
    end
  end
end
