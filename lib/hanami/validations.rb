require 'hanami/validations/version'
require 'hanami/validations/schema'
require 'hanami/validations/rules'
require 'hanami/utils/class_attribute'
require 'hanami/utils/hash'

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
          include Utils::ClassAttribute

          class_attribute :schema
          self.schema = Schema.new
        end
      end

      # Define a validation for an existing attribute
      #
      # @param name [#to_sym] the name of the attribute
      # @param options [Hash] set of validations
      #
      # @see Hanami::Validations::ClassMethods#validations
      #
      # @example Presence
      #   require 'hanami/validations'
      #
      #   class Signup
      #     include Hanami::Validations
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
      def validates(name, &blk)
        schema.add Rules.new(name.to_sym, blk)
      end

      def group(name, &blk)
        schema.group(name, &blk)
      end

      def predicate(name, &blk)
        schema.predicate(name, &blk)
      end
    end

    def initialize(data)
      @data = data
    end

    # Validates the object.
    #
    # @return []
    #
    # @since 0.2.4
    # @api private
    #
    # @see Hanami::Attribute#nested
    def validate
      self.class.schema.call(@data)
    end

    # Returns a Hash with the defined attributes as symbolized keys, and their
    # relative values.
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def to_h
      # TODO: remove this symbolization when we'll support Ruby 2.2+ only
      Utils::Hash.new(
        @data
      ).deep_dup.symbolize!.to_h
    end
  end
end
