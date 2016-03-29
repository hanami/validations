module Hanami
  module Validations
    # A single validation on an attribute
    #
    # @since 0.x.0
    # @api private
    class AttributeValidation
      # The name of the attribute being validated
      #
      # @return [Symbol] the name of the attribute
      #
      # @since 0.x.0
      attr_reader :attribute_name

      # The key of the validation. For the built-in validations the validation_key is the same
      # as the validation name, but for custom validations it is not.
      #
      # @return [Symbol] the name of the validation
      #
      # @since 0.x.0
      attr_reader :validation_key

      # @param attribute_name [Symbol] the attribute name
      # @param validation_key [Symbol] the validation key
      # @param validation_options [Object] the validation options
      #
      # @since 0.x.0
      # @api private
      def initialize(attribute_name, validation_key, validation_options)
        @attribute_name = attribute_name
        @validation_key = validation_key
        @validation_options = validation_options
      end

      # Validates the attribute
      #
      # @param attributes [Hash] the attributes values
      # @param errors [Hanami::Validations::Errors] the validation errors
      # @param namespace  [String] the namespace to use in the validation errors
      #
      # @since 0.x.0
      # @api private
      def validate(attributes, errors, namespace)
        if ValidationDefinitions.is_known?(validation_key)
          validate_with_known_validator(attributes, errors, namespace)
        else
          validate_with_custom_validator(attributes, errors, namespace)
        end
      end

      # Validates the attribute with a known validator
      #
      # @param attributes [Hash] the attributes values
      # @param errors [Hanami::Validations::Errors] the validation errors
      # @param namespace  [String] the namespace to use in the validation errors
      #
      # @since 0.x.0
      # @api private
      def validate_with_known_validator(attributes, errors, namespace)
        perform_validation_with(attributes, errors, namespace, known_validation)
      end

      # Validates the attribute with a custom validator
      #
      # @param attributes [Hash] the attributes values
      # @param errors [Hanami::Validations::Errors] the validation errors
      # @param namespace  [String] the namespace to use in the validation errors
      #
      # @since 0.x.0
      # @api private
      def validate_with_custom_validator(attributes, errors, namespace)
        perform_validation_with(attributes, errors, namespace, @validation_options)
      end

      # Validates the attribute with a validator class, instance or block
      #
      # @param attributes [Hash] the attributes values
      # @param errors [Hanami::Validations::Errors] the validation errors
      # @param validator_class_instance_or_block [Object] the validator factory
      # @param namespace  [String] the namespace to use in the validation errors
      #
      # @since 0.x.0
      # @api private
      def perform_validation_with(attributes, errors, namespace, validator_class_instance_or_block)
        validator_from(validator_class_instance_or_block).call(
          new_validation_context(attributes, errors, namespace)
        )
      end

      # Instantiates a validator from a validator class, instance or block
      #
      # @param validator_class_instance_or_block [Object] the validator factory
      #
      # @return [Hanami::Validations::Validation] the Validation instance
      #
      # @since 0.x.0
      # @api private
      def validator_from(validator_class_instance_or_block)
        instantiate_validator_from(validator_class_instance_or_block)
      end

      # Instantiates a [Hanami::Validations::ValidationContext] with the attributes, errors,
      # attribute name, validation name and validation options
      #
      # @param attributes [Hash] the attributes values
      # @param errors [Hanami::Validations::Errors] the validation errors
      # @param namespace  [String] the namespace to use in the validation errors
      #
      # @return [Hanami::Validations::ValidationContext] the validation context
      #
      # @since 0.x.0
      # @api private
      def new_validation_context(attributes, errors, namespace)
        ValidationContext.new(
          attributes,
          errors,
          @attribute_name,
          namespace,
          validation_name,
          validation_options
        )
      end

      # Answers the validation block when the validation is a known validation
      #
      # @return [Proc] the validation block
      #
      # @since 0.x.0
      # @api private
      def known_validation
        ValidationDefinitions.at(validation_key)
      end

      # Answers the validation name, which can be different from the validation key
      # for custom validations
      #
      # @return [Symbol] the validation name
      #
      # @since 0.x.0
      # @api private
      def validation_name
        ValidationDefinitions.validation_name(validation_key)
      end

      # Answers the validation options.
      # For custom validations it will be UNDEFINED_VALUE.
      # For known validations it will be the validation options declared in the validation
      # definition
      #
      # @return [Object] the validation options
      #
      # @since 0.x.0
      # @api private
      def validation_options
        ValidationDefinitions.is_custom?(validation_key) ? 
          UNDEFINED_VALUE : @validation_options
      end

      # Instantiates a validator from a validator class, instance or block.
      # If the given validator factory is a class, it's instantiated sending #new to it. 
      # If the given validator factory is a Proc, it's instantiated wrapping it with a
      # Hanami::Validations::ValidationBlock.
      # If the given validator factory is any other object, it's instantiated by sending
      # #dup to it.
      #
      # @param validator_class_instance_or_block [Object] the validator factory
      #
      # @return [Hanami::Validations::Validation] the validation instance
      #
      # @since 0.x.0
      def instantiate_validator_from(validator_class_instance_or_block)
        if validator_class_instance_or_block.kind_of?(::Proc)
          ValidationBlock.new(validator_class_instance_or_block)
        elsif validator_class_instance_or_block.kind_of?(::Class)
          validator_class_instance_or_block.new
        else
          validator_class_instance_or_block.dup
        end
      end
    end
  end
end
