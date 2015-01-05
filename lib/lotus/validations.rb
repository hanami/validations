require 'lotus/utils/hash'
require 'lotus/validations/version'
require 'lotus/validations/blank_value_checker'
require 'lotus/validations/attribute_definer'
require 'lotus/validations/validation_set'
require 'lotus/validations/validator'
require 'lotus/validations/attribute'
require 'lotus/validations/errors'

module Lotus
  # Lotus::Validations is a set of lightweight validations for Ruby objects.
  #
  # @since 0.1.0
  module Validations
    # Override Ruby's hook for modules.
    #
    # @param base [Class] the target action
    #
    # @since 0.1.0
    # @api private
    #
    # @see http://www.ruby-doc.org/core/Module.html#method-i-included
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include AttributeDefiner
      end
    end

    # Validations DSL
    #
    # @since 0.1.0
    module ClassMethods
      # Override Ruby's hook for class inheritance. When a class includes
      # Lotus::Validations and it is subclassed, this passes
      # the attributes from the superclass to the subclass.
      #
      # @param base [Class] the target action
      #
      # @since x.x.x
      # @api private
      #
      # @see http://www.ruby-doc.org/core/Class.html#method-i-inherited
      def inherited(base)
        transfer_validations_to_base(base)
        super
      end

      # Override Ruby's hook for modules. When a module includes
      # Lotus::Validations and it is included in a class or module, this passes
      # the validations from the module to the base.
      #
      # @param base [Class] the target action
      #
      # @since 0.1.0
      # @api private
      #
      # @see http://www.ruby-doc.org/core/Module.html#method-i-included
      #
      # @example
      #   require 'lotus/validations'
      #
      #   module NameValidations
      #     include Lotus::Validations
      #
      #     attribute :name, presence: true
      #   end
      #
      #   class Signup
      #     include NameValidations
      #   end
      #
      #   signup = Signup.new(name: '')
      #   signup.valid? # => false
      #
      #   signup = Signup.new(name: 'Luca')
      #   signup.valid? # => true
      def included(base)
        base.class_eval do
          include Lotus::Validations
        end

        super

        transfer_validations_to_base(base)
      end

      # Define a validation for an existing attribute
      #
      # @param name [#to_sym] the name of the attribute
      # @param options [Hash] set of validations
      #
      # @see Lotus::Validations::ClassMethods#validations
      #
      # @example Presence
      #   require 'lotus/validations'
      #
      #   class Signup
      #     include Lotus::Validations
      #
      #     def initialize(attributes = {})
      #       @name = attributes.fetch(:name)
      #     end
      #
      #     attr_accessor :name
      #
      #     validates :name, presence: true
      #   end
      #
      #   signup = Signup.new(name: 'Luca')
      #   signup.valid? # => true
      #
      #   signup = Signup.new(name: nil)
      #   signup.valid? # => false
      def validates(name, options)
        validations.add(name, options)
      end

      # Set of user defined validations
      #
      # @return [Hash]
      #
      # @since x.x.x
      # @api private
      def validations
        @validations ||= ValidationSet.new
      end

      private

      # Transfers attributes to a base class
      #
      # @param base [Module] the base class to transfer attributes to
      #
      # @since x.x.x
      # @api private
      def transfer_validations_to_base(base)
        validations.each do |attribute, options|
          base.validates attribute, options
        end
      end
    end

    # Validation errors
    #
    # @return [Lotus::Validations::Errors] the set of validation errors
    #
    # @since 0.1.0
    #
    # @see Lotus::Validations::Errors
    #
    # @example Valid attributes
    #   require 'lotus/validations'
    #
    #   class Signup
    #     include Lotus::Validations
    #
    #     attribute :email, presence: true, format: /\A(.*)@(.*)\.(.*)\z/
    #   end
    #
    #   signup = Signup.new(email: 'user@example.org')
    #   signup.valid? # => true
    #
    #   signup.errors
    #     # => #<Lotus::Validations::Errors:0x007fd594ba9228 @errors={}>
    #
    # @example Invalid attributes
    #   require 'lotus/validations'
    #
    #   class Signup
    #     include Lotus::Validations
    #
    #     attribute :email, presence: true, format: /\A(.*)@(.*)\.(.*)\z/
    #     attribute :age, size: 18..99
    #   end
    #
    #   signup = Signup.new(email: '', age: 17)
    #   signup.valid? # => false
    #
    #   signup.errors
    #     # => #<Lotus::Validations::Errors:0x007fe00ced9b78
    #     # @errors={
    #     #   :email=>[
    #     #     #<Lotus::Validations::Error:0x007fe00cee3290 @attribute=:email, @validation=:presence, @expected=true, @actual="">,
    #     #     #<Lotus::Validations::Error:0x007fe00cee31f0 @attribute=:email, @validation=:format, @expected=/\A(.*)@(.*)\.(.*)\z/, @actual="">
    #     #   ],
    #     #   :age=>[
    #     #     #<Lotus::Validations::Error:0x007fe00cee30d8 @attribute=:age, @validation=:size, @expected=18..99, @actual=17>
    #     #   ]
    #     # }>
    def errors
      @errors ||= Errors.new
    end

    # Checks if the current data satisfies the defined validations
    #
    # @return [TrueClass,FalseClass] the result of the validations
    #
    # @since 0.1.0
    def valid?
      validator = Validator.new(defined_validations, read_attributes)
      @errors = validator.validate

      errors.empty?
    end

    # Iterates thru the defined attributes and their values
    #
    # @param blk [Proc] a block
    # @yieldparam attribute [Symbol] the name of the attribute
    # @yieldparam value [Object,nil] the value of the attribute
    #
    # @since 0.2.0
    def each(&blk)
      to_h.each(&blk)
    end

    # Returns a Hash with the defined attributes as symbolized keys, and their
    # relative values.
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def to_h
      Utils::Hash.new(read_attributes).deep_dup
    end

    private
    # The set of user defined validations.
    #
    # @since x.x.x
    # @api private
    #
    # @see Lotus::Validations::ClassMethods#validations
    def defined_validations
      self.class.__send__(:validations)
    end

    # Builds a Hash of current attribute values.
    #
    # @since x.x.x
    # @api private
    def read_attributes
      {}.tap do |attributes|
        defined_validations.each_key do |attribute|
          attributes[attribute] = public_send(attribute)
        end
      end
    end
  end
end
