require_relative 'attribute_validation'

module Hanami
  module Validations
    # A set of validations defined on an object
    #
    # @since 0.2.2
    # @api private
    class ValidationSet
      # @since 0.2.2
      # @api private
      def initialize
        @validations = Array.new
        @attributes = Set.new
      end

      # @since 0.2.2
      # @api private
      def add(name, options)
        add_attribute_name(name)
        validate_options!(name, options).each_pair do |validation_name, validation_options|
          add_attribute_validation(AttributeValidation.new(name, validation_name, validation_options))
        end
      end

      # @since 0.x.0
      # @api private
      def add_attribute_validation(attribute_validation)
        add_attribute_name(attribute_validation.attribute_name)
        @validations << attribute_validation
      end

      # @since 0.x.0
      # @api private
      def add_attribute_name(attribute_name)
        @attributes.add(attribute_name.to_sym)
      end

      # @since 0.2.2
      # @api private
      def each(&blk)
        @validations.each(&blk)
      end

      # @since 0.2.2
      # @api private
      def each_key(&blk)
        names.each(&blk)
      end

      # @since 0.2.3
      # @api private
      def names
        @attributes
      end

      # Validates the validations in this set
      #
      # @param attributes  [Hash]  the attributes values
      # @param errors  [Hanami::Validations::Errors]  the validation erros
      # @param namespace  [String] Optional - the namespace to use in the validation errors
      #
      # @return [Hanami::Validations::Errors] the validation erros
      #
      # @since 0.x.0
      # @api private
      def validate(attributes, errors, namespace)
        errors.clear
        self.each do |validation|
          validation.validate(attributes, errors, namespace)
        end
        errors
      end

      private
      # Checks at the loading time if the user defined validations are recognized
      #
      # @param name [Symbol] the attribute name
      # @param options [Hash] the set of validations associated with the given attribute
      #
      # @raise [ArgumentError] if at least one of the validations are not
      #   recognized
      #
      # @since 0.2.2
      # @api private
      def validate_options!(name, options)
        if (unknown = unkown_validations(options.keys)) && unknown.any?
          raise ArgumentError.new(%(Unknown validation(s): #{ unknown.join ', ' } for "#{ name }" attribute))
        end

        # FIXME remove
        if options[:confirmation]
          add(:"#{ name }_confirmation", {})
        end

        options
      end

      # Answer a collection with the uknown validations in the validation_keys
      #
      # @param validation_keys [Array] the validation keys
      #
      # @since 0.x.0
      # @api private
      def unkown_validations(validation_keys)
        validation_keys.reject { |key| ValidationDefinitions.includes?(key) }
      end
    end
  end
end
