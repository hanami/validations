# frozen_string_literal: true

require "dry/validation"
require "delegate"

module Hanami
  # @since 0.1.0
  module Validations
    class Error < StandardError; end

    require "hanami/validations/version"
    require "hanami/validator"

    def self.included(klass)
      super
      klass.extend(ClassMethods)
    end

    # @since 2.0.0
    # @api private
    class Result < SimpleDelegator
      # @since 2.0.0
      # @api private
      def output
        __getobj__.to_h
      end

      # @since 2.0.0
      # @api private
      def messages
        __getobj__.errors.to_h
      end
    end

    # Validations DSL
    #
    # @since 0.1.0
    module ClassMethods
      # Define validation rules from the given block.
      #
      # @param blk [Proc] validation rules
      #
      # @since 0.6.0
      #
      # @see https://guides.hanamirb.org/validations/overview
      #
      # @example Basic Example
      #   require "hanami/validations"
      #
      #   class Signup
      #     include Hanami::Validations
      #
      #     validations do
      #       required(:name).filled(:string)
      #     end
      #   end
      #
      #   result = Signup.new(name: "Luca").validate
      #
      #   result.success? # => true
      #   result.messages # => []
      #   result.output   # => {:name=>""}
      #
      #   result = Signup.new(name: "").validate
      #
      #   result.success? # => false
      #   result.messages # => {:name=>["must be filled"]}
      #   result.output   # => {:name=>""}
      def validations(&blk)
        @_validator = Dry::Validation::Contract.build { schema(&blk) }
      end

      def _validator
        @_validator
      end
    end

    # Initialize a new instance of a validator
    #
    # @param input [#to_h] a set of input data
    #
    # @since 0.6.0
    def initialize(input)
      @input = input
    end

    # Validates the object.
    #
    # @return [Hanami::Validations::Result]
    #
    # @since 0.2.4
    def validate
      Result.new(
        self.class._validator.call(@input)
      )
    end

    # Returns a Hash with the defined attributes as symbolized keys, and their
    # relative values.
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def to_h
      validate.to_h
    end
  end
end
