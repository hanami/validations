require 'lotus/validations/version'
require 'lotus/validations/attribute_validator'

module Lotus
  module Validations
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def attribute(name, options = {})
        attributes[name] = options

        class_eval %{
          def #{ name }
            @attributes[:#{ name }]
          end
        }
      end

      private
      def attributes
        @attributes ||= Hash.new
      end
    end

    attr_reader :attributes, :errors

    def initialize(attributes)
      @attributes = attributes
      @errors     = Hash.new {|h,k| h[k] = [] }
    end

    def valid?
      _attributes.each do |name, options|
        AttributeValidator.new(self, name, options).validate!
      end

      @errors.empty?
    end

    private
    def _attributes
      self.class.__send__(:attributes)
    end
  end
end
