require 'dry-validation'
require 'hanami/utils/class_attribute'
require 'hanami/validations/namespace'
require 'hanami/validations/predicates'
require 'hanami/validations/inline_predicate'
require 'hanami/validations/dsl'
require 'set'

Dry::Validation::Messages::Namespaced.configure do |config|
  config.lookup_paths = config.lookup_paths + %w[
    %<root>s.%<rule>s.%<predicate>s
  ].freeze
end

# @since 0.1.0
module Hanami
  # Hanami::Validations is a set of lightweight validations for Ruby objects.
  #
  # @since unstable
  #
  # @example
  #   require 'hanami/validations'
  #
  #   class Signup < include Hanami::Validations
  #
  #     validations do
  #       # ...
  #     end
  #   end
  class Validations
    include Validations::Dsl

    # Initialize a new instance of a validator
    #
    # @param input [#to_h] a set of input data
    #
    # @since 0.6.0
    def initialize(input = {})
      @input = input.to_h
    end

    # Validates the object.
    #
    # @return [Dry::Validations::Result]
    #
    # @since next
    # @api unstable
    def call(input)
      @result = self.class.schema.call(input)

      @result
    end

    # Returns a Hash with the defined attributes as symbolized keys, and their
    # relative values.
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def to_h
      return {} unless defined?(@result)

      @result.output
    end
  end
end
