module Lotus
  module Validations
    module Validation
      def initialize(attribute, other_attributes, errors, namespace = nil)
        @attribute = attribute
        @other_attributes = other_attributes
        @errors = errors
        @namespace = namespace
      end

      def call
      end

      def validation
        self.class.name.match(/(^[A-Z]+[^A-Z]*)/)[0].downcase
      end

      def add_error(expected, actual)
        Error.new(attribute.name, validation, expected, actual, namespace)
      end
    end
  end
end
