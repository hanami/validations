module Lotus
  module Validations
    module Validator
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      attr_reader :value, :error

      def initialize(value)
        @value = value
      end

      module ClassMethods
        def call(value)
          new(value).valid?
        end
      end
    end
  end
end
