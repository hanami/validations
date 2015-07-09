module Lotus
  module Validations
    module Validator
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      attr_reader :value, :validator

      def initialize(attributes, name, value)
        @attributes = attributes
        @name = name
        @validator_value = value
        @value = @attributes[@name]
      end

      def validator_name
        self.class.to_s
      end

      def generate_errors
        Error.new(validator_name, @validator_value, @value)
      end

      def validate
        valid? || generate_errors
      end

      module ClassMethods
        def call(attributes, name, value)
          new(attributes, name, value).validate
        end
      end
    end
  end
end
