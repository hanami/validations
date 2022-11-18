# frozen_string_literal: true

require "dry/validation"
require "delegate"
require "zeitwerk"

# @see Hanami::Validations
# @since 0.1.0
module Hanami
  # @since 0.1.0
  # @api private
  module Validations
    # @since 2.0.0
    # @api private
    def self.gem_loader
      @gem_loader ||= Zeitwerk::Loader.new.tap do |loader|
        root = File.expand_path("..", __dir__)
        loader.tag = "hanami-validations"
        loader.inflector = Zeitwerk::GemInflector.new("#{root}/hanami-validations.rb")
        loader.push_dir(root)
        loader.ignore(
          "#{root}/hanami-validations.rb",
          "#{root}/hanami/validations/version.rb"
        )
      end
    end

    gem_loader.setup
    require_relative "validations/version"

    # @since 0.1.0
    # @api private
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
    # @api private
    module ClassMethods
      # Define validation rules from the given block.
      #
      # @param blk [Proc] validation rules
      #
      # @since 0.6.0
      # @api private
      def validations(&blk)
        @_validator = Dry::Validation::Contract.build { schema(&blk) }
      end

      # @since 2.0.0
      # @api private
      def _validator
        @_validator
      end
    end

    # Initialize a new instance of a validator
    #
    # @param input [#to_h] a set of input data
    #
    # @since 0.6.0
    # @api private
    def initialize(input)
      @input = input
    end

    # Validates the object.
    #
    # @return [Hanami::Validations::Result]
    #
    # @since 0.2.4
    # @api private
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
    # @api private
    def to_h
      validate.to_h
    end
  end
end
