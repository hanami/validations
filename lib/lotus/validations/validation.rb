module Lotus
  module Validations
    # A mixin for defining validations.
    # The including class must override #call.
    #
    # @example
    #   class UserNamePolicyValidator
    #     include Lotus::Validations::Validation
    #
    #     def call
    #       if BannedWordsRepository.where(word: value.downcase).any?
    #         add_error(false, validation_name: :banned_user_name)
    #       end
    #     end
    #   end
    #
    #   class Signup
    #     include Lotus::Validations
    #
    #     def initialize(attributes = {})
    #       @name = attributes.fetch(:name)
    #     end
    #
    #     attr_accessor :name, :email
    #
    #     validates :name, presence: true
    #     validates :name, with: UserNamePolicyValidator
    #   end
    #
    #   signup = Signup.new(name: "very offensive user name")
    #   signup.valid? # => false
    #   signup.errors.for(:name) => [#<Lotus::Validations::Error:0x00000001a1d1b8
    #                                @actual=false",
    #                                @attribute="name",
    #                                @attribute_name="name",
    #                                @expected=true,
    #                                @namespace=nil,
    #                                @validation=:banned_user_name>]
    #
    module Validation
      # The name of the attribute
      #
      # @return [Symbol] the name of the attribute
      #
      attr_reader :attribute_name

      # The value of the attribute
      #
      # @return [Object] the value of the attribute
      #
      attr_reader :value

      # The set of attributes and values coming from the input
      #
      # @return [Hash] the attributes
      #
      attr_reader :attributes

      # The set of errors
      #
      # @return [Lotus::Validations::Error] the attributes
      #
      attr_reader :errors

      def initialize(attribute_name, attributes, errors)
        @attribute_name = attribute_name
        @value = attributes[attribute_name]
        @attributes = attributes
        @errors = errors
      end

      # This method must be overriden. It should implement
      # the validation logic and add an error by calling #add_error
      #
      # @see Lotus::Validatios::Validation#add_error
      #
      def call
        fail NotImplementedError
      end

      # Builds the default validation name from the class name.
      # If no validation name is given when using Lotus::Validatios::Validation#add_error
      # this method will be called. It takes the class name and modifieds it.
      # @return [Symbol] the generated default validation name
      #
      # @example
      #   class MyValidations::IsAValidaValueValidator; # ...; end
      #   validator = MyValidations::IsAValidaValueValidator.new(...)
      #   validator.default_validation_name # => :is_a_valid_value
      #
      def default_validation_name
        @default_validation_name ||= begin
                               class_name = Utils::String.new(self.class.name)
                                 .demodulize
                                 .underscore
                                 .gsub('_validator', '')
                                 .to_sym
                             end
      end

      # Adds an error to the error set
      #
      # @param expected [Object] the expected valued
      # @param options [Hash] options optional options to create the error with
      # @option options [String] namespace optional namespace that is passed to the error
      # @option options [Symbol] validation_name optional validation_name that is passed
      #   to the error. It defaults to Lotus::Validatios::Validation#default_validation_name
      #
      # @see Lotus::Validations::Error#initialize
      #
      def add_error(expected, options = {})
        validation_name = options.fetch(:validation_name) { default_validation_name }
        namespace = options.fetch(:namespace, nil)
        error = Error.new(attribute_name, validation_name, expected, value, namespace)
        @errors.add(attribute_name, error)
      end
    end
  end
end
