require_relative 'validation_block'

module Hanami
  module Validations
    # This class acts a singleton and holds the built-in validation definitions.
    # It also answers whether a validation name is built-in or custom.
    #
    # @example
    #   Hanami::Validations::ValidationDefinitions.define do
    #     validation :presence do
    #       add_error if blank_value?
    #     end
    #
    #     validation :address, with: AddressValidator
    #   end
    #
    # @since 0.x.0
    class ValidationDefinitions
      class << self
        # The custom validations pattern
        #
        # @since 0.2.0
        # @api private
        CUSTOM_VALIDATION_PATTERN = /validate_([[:alnum:]_]+)_with/.freeze

        # @result [Hash] the collection of built-in validations
        #
        # @since 0.x.0
        # @api private
        def validations
          @validations ||= Hash[]
        end

        # Evaluates a block binding self to the class.
        #
        # @param &block [Proc] the block to define validations
        #
        # @example
        #   Hanami::Validations::ValidationDefinitions.define do
        #     validation :presence do
        #       add_error unless !blank_value?
        #     end
        #   end
        #
        # @since 0.x.0
        def define(&block)
          instance_eval(&block)
        end

        # Defines a built-in validation.
        #
        # @param name [Symbol] the validation name
        # @param with [Class|Object|Proc] Optional - the validator factory
        # @param &block [Proc] Optional - the validator block
        #
        # @example
        #   Hanami::Validations::ValidationDefinitions.define do
        #     validation :presence do
        #       add_error unless !blank_value?
        #     end
        #
        #     validation :address, with: AddressValidator
        #   end
        #
        # @since 0.x.0
        def validation(name, with: nil, &block)
          raise 'At least one validator factory must be provided' if with.nil? && block.nil?
          raise 'Only one validator factory is admited' if !with.nil? && !block.nil?

          with = block if with.nil? && !block.nil?
          validations[name] = with
        end

        # Answers the validation block for the validation named validation_name
        #
        # @param validation_name [Symbol] the validation name
        #
        # @return [Proc] the validation block
        #
        # @since 0.x.0
        # @api private
        def at(validation_name)
          validations[validation_name]
        end

        # Answers whether a validation_key is an accepted validation key or not
        # It can be either a built-in or a custom validation
        #
        # @param validation_key [Symbol] the validation key
        #
        # @return [Boolean] whether the validation_key is an accepted validation key or not
        #
        # @since 0.x.0
        def includes?(validation_key)
          is_known?(validation_key) || is_custom?(validation_key)
        end

        # Answers whether a validation_key is a built-in validation or not
        #
        # @param validation_key [Symbol] the validation key
        #
        # @return [Boolean] whether a validation_key is a built-in validation name or not
        #
        # @since 0.x.0
        def is_known?(validation_key)
          validations.include?(validation_key)
        end

        # Answers whether a validation_key is a custom validation or not
        #
        # @param validation_key [Symbol] the validation key
        #
        # @return [Boolean] whether a validation_key is a custom validation name or not
        #
        # @since 0.x.0
        def is_custom?(validation_key)
          CUSTOM_VALIDATION_PATTERN.match(validation_key)
        end

        # Answers the actual validation name of a validation key
        #
        # @param validation_key [Symbol] the validation key
        #
        # @return [Symbol] the actual validation name of a custom validation key
        #
        # @since 0.x.0
        def validation_name(validation_key)
          is_known?(validation_key) ? validation_key : custom_validation_name(validation_key)
        end

        # Answers the actual validation name of a custom validation key
        #
        # @param validation_key [Symbol] the validation key
        #
        # @return [Symbol] the actual validation name of a custom validation key
        #
        # @since 0.x.0
        # @api private
        def custom_validation_name(validation_key)
          CUSTOM_VALIDATION_PATTERN.match(validation_key)[1].to_sym
        end
      end
    end
  end
end
