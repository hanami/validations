module Lotus
  module Validations
    class Validator
      def initialize(validation_set, attributes)
        @validation_set = validation_set
        @attributes = attributes
      end

      def validate
        Errors.new.tap do |errors|
          @validation_set.each do |name, validations|
            value = @attributes[name]
            value = @attributes[name.to_s] if value.nil?

            attribute = Attribute.new(@attributes, name, value, validations)
            errors.add name, *attribute.validate
          end
        end
      end
    end
  end
end
