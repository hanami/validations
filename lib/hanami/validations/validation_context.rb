module Hanami
  module Validations
    # An object to validate a default attribute or any other attribute as well.
    #
    # By using Hanami::Validations::ValidationContext you have access
    # to the following protocol:
    #
    # @example
    #   # Get the value of the attribute being validated
    #   validation_context.value
    #   
    #   # Get the value of any attribute
    #   validation_context.value_of('name')
    #   
    #   # Get the validation name
    #   validation_context.validation_name
    #   
    #   # Override the validation name
    #   validation_context.validation_name :location_existance
    #   
    #   # Get the name of the attribute being validate
    #   validation_context.attribute_name
    #   
    #   # Get the namespace of the attribute being validate
    #   validation_context.namespace
    #   
    #   # Answer whether the attribute being validated is blank or not
    #   validation_context.blank_value?
    #   
    #   # Answer whether a previous validation failed for the attribute being validated or not
    #   validation_context.validation_failed_for? :size
    #   
    #   # Answer whether a previous validation failed for another attribute or not
    #   validation_context.validation_failed_for? :size, on: 'name'
    #   
    #   # Add a default error for the attribute being validated
    #   validation_context.add_error
    #   
    #   # Add an error for the attribute being validated overriding any of these parameters:
    #   # :validation_name, :expected_value, :actual_value, :namespace
    #   validation_context.add_error expected_value: 'An existent address'
    #   
    #   # Add an error for any attribute defining all of these parameters:
    #   # :validation_name, :expected_value, :actual_value, :namespace
    #   validation_context.add_error_for 'name', validation_name: validation_name, expected_value: true, actual_value: value_of('name'), namespace: nil
    #
    #   # Validate any attribute with any validation
    #   validate_attribute 'address.street', on: :format, with: /abc/
    #
    # @since 0.x.0
    # @api private
    class ValidationContext
      # @return [Hash] the attributes values
      #
      # @since 0.x.0
      attr_reader :attributes

      # @return [Hanami::Validations::Errrors] the validations errors
      #
      # @since 0.x.0
      attr_reader :errors

      # @param validation_name [Symbol] if present, sets the validation name
      #
      # @result [Symbol] the validation name
      #
      # @since 0.x.0
      attr_reader :attribute_name

      # @result [String|nil] the attribute namespace
      #
      # @since 0.x.0
      attr_reader :namespace

      # @return [Object] the validation expected value
      #
      # @since 0.x.0
      attr_reader :expected_value

      # @param attributes [Hash] the attributes values
      # @param errors [Hanami::Validations::Errrors] the validations errors
      # @param attribute_name [String] the default attribute name
      # @param namespace [String] the default attribute namespace
      # @param validation_name [Symbol] the default validation name
      # @param expected_value [Object] the default expected value
      #
      # @since 0.x.0
      def initialize(attributes, errors, attribute_name = nil, namespace = nil, validation_name = nil, expected_value = UNDEFINED_VALUE)
        @attributes = attributes
        @errors = errors
        @attribute_name = attribute_name
        @namespace = namespace
        @validation_name = validation_name
        @expected_value = undefined?(expected_value) ? default_expected_value : expected_value
      end

      # Answers or sets the validation name
      #
      # @param validation_name [Symbol] Optional - if present, sets the validation name
      #
      # @result [Symbol] the validation name
      #
      # @since 0.x.0
      def validation_name(validation_name = UNDEFINED_VALUE)
          @validation_name = validation_name unless undefined?(validation_name)

          @validation_name
      end

      # Answers the value of the attribute being validated
      #
      # @result [Object] the attribute value
      #
      # @since 0.x.0
      def value
        value_of(attribute_name)
      end

      # Answers the value of the attribute named attribute_name
      #
      # @param attribute_name [String] the attribute name
      #
      # @result [Object] the attribute value
      #
      # @since 0.x.0
      def value_of(attribute_name)
        attribute_name.to_s.split('.').inject(attributes) do |attributes, accessor|
          read_value_from(attributes, accessor)
        end
      end

      # Answers the value of the accessor in the attributes object.
      # Attributes can be either a Hash or a Hanami::Validations::NestedAttributes
      #
      # @param attribute_name [String] the attribute name
      #
      # @result [Object] the attribute value
      #
      # @since 0.x.0
      def read_value_from(attributes, accessor)
        attributes.public_send(accessor.to_sym)
      end

      # Answers whether the attribute being validated is blank or not
      #
      # @return [Boolean] whether the attribute is blank or not
      #
      # @since 0.x.0
      def blank_value?
        BlankValueChecker.new(value).blank_value?
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
        attribute_name = self.attribute_name if undefined?(attribute_name)
        validation_name = self.validation_name if undefined?(validation_name)
        expected_value = self.expected_value if undefined?(expected_value)
        actual_value = self.value if undefined?(actual_value)
        namespace = self.namespace if undefined?(namespace)

        add_error_for(
          attribute_name,
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
      def add_error_for(attribute_name, validation_name:, expected_value:, actual_value:, namespace:)
        add_validation_error(
            Hanami::Validations::Error.new(
                attribute_name,
                validation_name,
                expected_value,
                actual_value,
                namespace
            )
        )
      end

      # Adds a [Hanami::Validations::Error] to the validation errors
      #
      # @param validation_error [Hanami::Validations::Error] the error to add
      #
      # @since 0.x.0
      def add_validation_error(validation_error)
        errors.add(validation_error.attribute.to_sym, validation_error)
      end

      # Validates another attribute with a specific validation
      #
      # @param attribute_name [String] the name of the attribute to validate
      # @param on [Symbol] the name of the validation. For custom validations, it's
      #           the actual validation name, for intance, :cutom and not :validate_custom_with
      # @param with [Object] Optional - the parameters of the validation. For 
      #           custom validations, it's the validator class, instance or block
      #
      # @since 0.x.0
      def validate_attribute(attribute_name, on:, with: nil)
        accessors = attribute_name.to_s.split('.')

        attribute = attribute_name.to_sym
        namespace = nil
        attributes = self.attributes

        unless accessors.size == 1
          attribute = accessors.last.to_sym
          namespace = accessors[0..-2].join('.')
          attributes = value_of(namespace)
        end

        AttributeValidation.new(attribute, on, with)
          .validate(attributes, errors, namespace)
      end

      # Answers wheter the validation for another attribute failed or not
      #
      # @param validation_name [Symbol] the name of the validation. For custom validations,
      #   it'sthe actual validation name, for intance, :custom and not :validate_custom_with
      # @param on [String] the name of the attribute to ask if the validation failed or not
      #
      # @return [Boolean] wheter the attribute validation failed or not
      #
      # @since 0.x.0
      def validation_failed_for?(validation_name, on: nil)
        attribute_name = on.nil? ? self.attribute_name : on
        !errors.for(attribute_name).empty?
      end

      protected

      # Answers the value to use as the expected value when none was provided
      #
      # @return [Object] the default expected value
      #
      # @since 0.x.0
      def default_expected_value
        true
      end

      # Answers wheter a parameter is undefined or not
      #
      # @param value [Object] a parameter
      #
      # @return [Boolean] wheter the parameter is undefined or not
      #
      # @since 0.x.0
      def undefined?(value)
        value == UNDEFINED_VALUE
      end
    end
  end
end
