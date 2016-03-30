module Hanami
  module Validations
    # A mixin to include in validator classes.
    # By including this mixin, the object can act as a validator.
    # It must respond to #validate, and validate the attribute there.
    #
    # By including include Hanami::Validations::Validation in your class, you have access
    # to the following protocol:
    #
    # @example
    #   # Get the value of the attribute being validated
    #   value
    # 
    #   # Get the value of any attribute
    #   value_of('address.street')
    # 
    #   # Get the validation name
    #   validation_name
    # 
    #   # Override the validation name
    #   validation_name :location_existance
    # 
    #   # Get the name of the attribute being validated
    #   attribute_name
    # 
    #   # Get the namespace of the attribute being validated
    #   namespace
    # 
    #   # Answer whether the attribute being validated is blank or not
    #   blank_value?
    # 
    #   # Answer whether any value is blank or not
    #   blank_value?(value_of 'address.street')
    # 
    #   # Answer whether a previous validation failed for the attribute being validated or not
    #   validation_failed_for? :size
    # 
    #   # Answer whether a previous validation failed for another attribute or not
    #   validation_failed_for? :size, on: 'address.street'
    # 
    #   # Answer whether a previous validation failed for the attribute being validated or not
    #   any_validation_failed?
    # 
    #   # Answer whether any previous validation failed for another attribute or not
    #   any_validation_failed? on: 'address.street'
    # 
    #   # Add a default error for the attribute being validated
    #   add_error
    # 
    #   # Add an error for the attribute being validated overriding any of these parameters:
    #   # :validation_name, :expected_value, :actual_value, :namespace
    #   add_error expected_value: 'An existent address'
    # 
    #   # Add an error for any attribute defining all of these parameters:
    #   # :validation_name, :expected_value, :actual_value, :namespace
    #   add_error_for 'street',
    #     namespace: 'address', validation_name: validation_name,
    #     expected_value: true, actual_value: value_of('address.street')
    # 
    #   # Validate any attribute with any validation
    #   validate_attribute 'address.street', on: :format, with: /abc/
    #
    #   # Answers the validation errors for an attribute.
    #   errors_for 'name'
    #   errors_for 'address.street'
    #
    # @example
    #   class AddressExistenceValidator
    #     include Hanami::Validations::Validation
    #     
    #     def validate
    #       add_error unless address_exists?
    #     end
    #   
    #     def address
    #       value
    #     end
    #   
    #     def address_exists?
    #       query_address.matches_count == 1
    #     end
    #   
    #     def query_address
    #       AddressQueryService.new.query_address(address)
    #     end
    #   end
    #
    # @since 0.x.0
    # @api private
    module Validation
      # The validation context to perform the validation
      #
      # @return [Hanami::Validations::ValidationContext] the validation context
      #
      # @since 0.x.0
      attr_reader :validation_context

      # The entry point of every validator
      #
      # @param validation_context [Hanami::Validations::ValidationContext] the validation context
      #
      # @since 0.x.0
      def call(validation_context)
          @validation_context = validation_context

          validate
      end

      # The validation method. You must define this method in your base class
      #
      # @since 0.x.0
      def validate
          raise "The class #{self.class.name} must define #validate"
      end

      # Accessing

      # @return [Hash] the attributes values
      #
      # @since 0.x.0
      def attributes
          validation_context.attributes
      end

      # @return [Hanami::Validations::Errors] the validations errors
      #
      # @since 0.x.0
      def errors
          validation_context.errors
      end

      # @return [String] the name of the attribute being validated
      #
      # @since 0.x.0
      def attribute_name
          validation_context.attribute_name
      end

      # @param validation_name [Symbol] if provided, sets the validation name
      #
      # @return [Symbol] the name of the validation
      #
      # @since 0.x.0
      def validation_name(validation_name = ValidationContext::UNDEFINED_VALUE)
          validation_context.validation_name(validation_name)
      end

      # @return [String] the namespace of the attribute being validated
      #
      # @since 0.x.0
      def namespace
          validation_context.namespace
      end

      # @return [Object] the value of the attribute being validated
      #
      # @since 0.x.0
      def value
          validation_context.value
      end

      # Answers the value of an atribute
      #
      # @param attribute_name [String] the name of the attribute
      #
      # @return [Object] the value of the attribute
      #
      # @since 0.x.0
      def value_of(attribute_name)
          validation_context.value_of(attribute_name)
      end

      # Answers whether the attribute being validated is blank or not
      #
      # @return [Boolean] whether the attribute is blank or not
      #
      # @since 0.x.0
      def blank_value?
        validation_context.blank_value?
      end


      # Adds an error to the validation errors
      #
      # @param attribute_name [String] Optional - the name of the attribute error
      # @param validation_name [Symbol] Optional - the name of the validation error
      # @param expected_value [Object] Optional - the expected value of the attribute error
      # @param actual_value [Object] Optional - the actual value of the attribute error
      # @param namespace [String] Optional - the namespace of the attribute error
      #
      # @since 0.x.0
      def add_error(
            attribute_name: UNDEFINED_VALUE,
            validation_name: UNDEFINED_VALUE,
            expected_value: UNDEFINED_VALUE,
            actual_value: UNDEFINED_VALUE,
            namespace: UNDEFINED_VALUE
          )
          validation_context.add_error(
            attribute_name: attribute_name,
            validation_name: validation_name,
            expected_value: expected_value,
            actual_value: actual_value,
            namespace: namespace
          )
      end

      # Adds an error for an attribute to the validation errors
      #
      # @param attribute_name [String] the name of the attribute error
      # @param validation_name [Symbol] the name of the validation error
      # @param expected_value [Object] the expected value of the attribute error
      # @param actual_value [Object] the actual value of the attribute error
      # @param namespace [String] the namespace of the attribute error
      #
      # @since 0.x.0
      def add_error_for(
            attribute_name,
            validation_name:,
            expected_value:,
            actual_value:,
            namespace:
          )
          validation_context.add_error_for(
            attribute_name,
            validation_name: validation_name,
            expected_value: expected_value,
            actual_value: actual_value,
            namespace: namespace
          )
      end

      # Adds a [Hanami::Validations::Error] to the validation errors
      #
      # @param validation_error [Hanami::Validations::Error] the error to add
      #
      # @since 0.x.0
      def add_validation_error(validation_error)
          validation_context.add_validation_error(validation_error)
      end

      # Validates the attribute being validated with a specific validation
      #
      # @param validation_name [Symbol] the name of the validation. For custom validations, it's
      #           the actual validation name, for intance, :cutom and not :validate_custom_with
      # @param with [Object] Optional - the parameters of the validation. For 
      #           custom validations, it's the validator class, instance or block
      #
      # @return [Boolean]  true if the validation passed, false if failed
      #
      # @since 0.x.0
      def validate_on(validation_name, with: nil)
        validation_context.validate_on(validation_name, with: with)
      end

      # Validates another attribute with a specific validation
      #
      # @param attribute_name [String] the name of the attribute to validate
      # @param on [Symbol] the name of the validation. For custom validations, it's
      #           the actual validation name, for intance, :cutom and not :validate_custom_with
      # @param with [Object] Optional - the parameters of the validation. For 
      #             custom validations, it's the validator class, instance or block
      #
      # @return [Boolean]  true if the validation passed, false if failed
      #
      # @since 0.x.0
      def validate_attribute(attribute_name, on:, with: nil)
          validation_context.validate_attribute(attribute_name, on: on, with: with)
      end

      # Answers wheter a given validation for an attribute failed or not.
      # If no attribute name is given, asks for the attribute being validated.
      #
      # @param validation_name [Symbol] the name of the validation. For custom validations,
      #   it's the actual validation name, for intance, :custom and not :validate_custom_with
      # @param on [String] Optional - the name of the attribute to ask if the 
      #           validation failed or not
      #
      # @return [Boolean] wheter the attribute validation failed or not
      #
      # @since 0.x.0
      def validation_failed_for?(validation_name, on: nil)
          validation_context.validation_failed_for?(validation_name, on: on)
      end

      # Answers whether any previous validation failed for an attribute or not
      # If no attribute name is given, asks for the attribute being validated.
      #
      # @param on [String] Optional - the name of the attribute to ask if the 
      #           validation failed or not
      #
      # @return [Boolean] wheter the attribute validation failed or not
      #
      # @since 0.x.0
      def any_validation_failed?(on: nil)
        validation_context.any_validation_failed?(on: on)
      end

      # Answers the validation errors for an attribute.
      #
      # @param on [String] Optional - the name of the attribute
      #
      # @return [Array] a collection of [Hanami::Validations::Error]
      #
      # @since 0.x.0
      def errors_for(attribute_name)
        validation_context.errors_for(attribute_name)
      end
    end
  end
end
