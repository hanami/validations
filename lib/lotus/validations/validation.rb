module Lotus
  module Validations
    module Validation
      attr_reader :attribute_name, :value, :attributes, :errors

      def initialize(attribute_name, attributes, errors)
        @attribute_name = attribute_name
        @value = attributes[attribute_name]
        @attributes = attributes
        @errors = errors
      end

      def call
        fail NotImplementedError
      end

      def validation_name
        @validation_name ||= begin
                               class_name = self.class.name.split('::').last
                               class_name.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
                                 .gsub(/([a-z\d])([A-Z])/,'\1_\2')
                                 .downcase
                                 .gsub('_validator', '')
                                 .to_sym
                             end
      end

      def add_error(expected, actual)
        error = Error.new(attribute_name, validation_name, expected, actual)
        @errors.add(attribute_name, error)
      end
    end
  end
end
