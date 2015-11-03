require "lotus/utils/string"
module Lotus
  module Validations
    module Validation
      attr_reader :attribute_name
      attr_reader :value
      attr_reader :attributes
      attr_reader :errors

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
                               class_name = Utils::String.new(self.class.name)
                                 .demodulize
                                 .underscore
                                 .gsub('_validator', '')
                                 .to_sym
                             end
      end

      def add_error(expected, namespace = nil)
        error = Error.new(attribute_name, validation_name, expected, value, namespace)
        @errors.add(attribute_name, error)
      end
    end
  end
end
