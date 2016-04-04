require 'dry-validation'

module Hanami
  # Hanami::Validations is a set of lightweight validations for Ruby objects.
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
      base.extend ClassMethods
    end

    # Validations DSL
    #
    # @since 0.1.0
    module ClassMethods
      def self.extended(base)
        base.class_eval do
          @rules  = Dry::Validation::Schema::Value.new
          @schema = Class.new(Dry::Validation::Schema)

          @schema.configure { |c| c.rules = @rules.rules }
        end
      end

      def key(name, &blk)
        rules.key(name.to_sym, &blk)
      end

      def attr(name)
        rules.attr(name.to_sym)
      end

      def optional(name, &blk)
        rules.optional(name.to_sym, &blk)
      end

      def group(name, &blk)
        rules.key(name.to_sym).schema(&blk)
      end

      def rule(name, &blk)
        rules.rule(name, &blk)
      end

      def schema
        @schema
      end

      private

      def rules
        @rules
      end
    end

    def initialize(data)
      @data = data
    end

    # Validation errors
    #
    # @return [Hanami::Validations::Errors] the set of validation errors
    #
    # @since 0.1.0
    #
    # @see Hanami::Validations::Errors
    #
    # @example Valid attributes
    #   require 'hanami/validations'
    #
    #   class Signup
    #     include Hanami::Validations
    #
    #     attribute :email, presence: true, format: /\A(.*)@(.*)\.(.*)\z/
    #   end
    #
    #   signup = Signup.new(email: 'user@example.org')
    #   signup.valid? # => true
    #
    #   signup.errors
    #     # => #<Hanami::Validations::Errors:0x007fd594ba9228 @errors={}>
    #
    # @example Invalid attributes
    #   require 'hanami/validations'
    #
    #   class Signup
    #     include Hanami::Validations
    #
    #     attribute :email, presence: true, format: /\A(.*)@(.*)\.(.*)\z/
    #     attribute :age, size: 18..99
    #   end
    #
    #   signup = Signup.new(email: '', age: 17)
    #   signup.valid? # => false
    #
    #   signup.errors
    #     # => #<Hanami::Validations::Errors:0x007fe00ced9b78
    #     # @errors={
    #     #   :email=>[
    #     #     #<Hanami::Validations::Error:0x007fe00cee3290 @attribute=:email, @validation=:presence, @expected=true, @actual="">,
    #     #     #<Hanami::Validations::Error:0x007fe00cee31f0 @attribute=:email, @validation=:format, @expected=/\A(.*)@(.*)\.(.*)\z/, @actual="">
    #     #   ],
    #     #   :age=>[
    #     #     #<Hanami::Validations::Error:0x007fe00cee30d8 @attribute=:age, @validation=:size, @expected=18..99, @actual=17>
    #     #   ]
    #     # }>
    #
    # @example Invalid attributes
    #   require 'hanami/validations'
    #
    #   class Post
    #     include Hanami::Validations
    #
    #     attribute :title, presence: true
    #   end
    #
    #   post = Post.new
    #   post.invalid? # => true
    #
    #   post.errors
    #     # => #<Hanami::Validations::Errors:0x2931522b
    #     # @errors={
    #     #   :title=>[
    #     #     #<Hanami::Validations::Error:0x662706a7 @actual=nil, @attribute_name="title", @validation=:presence, @expected=true, @namespace=nil, @attribute="title">
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
      validate

      errors.empty?
    end

    # Checks if the current data doesn't satisfies the defined validations
    #
    # @return [TrueClass,FalseClass] the result of the validations
    #
    # @since 0.3.2
    def invalid?
      !valid?
    end

    # Validates the object.
    #
    # @return [Errors]
    #
    # @since 0.2.4
    # @api private
    #
    # @see Hanami::Attribute#nested
    def validate
      self.class.schema.new.call(@data)
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
      # TODO remove this symbolization when we'll support Ruby 2.2+ only
      Utils::Hash.new(
        @attributes
      ).deep_dup.symbolize!.to_h
    end

    private
    # The set of user defined validations.
    #
    # @since 0.2.2
    # @api private
    #
    # @see Hanami::Validations::ClassMethods#validations
    def defined_validations
      self.class.__send__(:validations)
    end

    # Builds a Hash of current attribute values.
    #
    # @since 0.2.2
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
