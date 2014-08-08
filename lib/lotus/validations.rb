require 'lotus/validations/version'
require 'lotus/validations/attribute_validator'

module Lotus
  module Validations
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def attribute(name, options = {})
        attributes[name.to_sym] = validate_options!(name, options)

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

      def validate_options!(name, options)
        if (unknown = (options.keys - validations)) && unknown.any?
          raise ArgumentError.new(%(Unknown validation(s): #{ unknown.join ', ' } for "#{ name }" attribute))
        end

        options
      end

      def validations
        [:presence, :acceptance, :format, :inclusion, :esclusion, :confirmation, :size, :type]
      end
    end

    attr_reader :attributes, :errors

    def initialize(attributes)
      @attributes = attributes
      @errors     = Hash.new {|h,k| h[k] = {} }
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
