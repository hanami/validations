# frozen_string_literal: true

require "dry-validation"
require "hanami/utils/class_attribute"
require "hanami/validations/namespace"
require "hanami/validations/predicates"
require "hanami/validations/inline_predicate"
require "set"

require "hanami/result"
require "hanami/utils/string"

Dry::Validation::Messages::Namespaced.configure do |config|
  # rubocop:disable Lint/NestedPercentLiteral
  #
  # This is probably a false positive.
  # See: https://github.com/bbatsov/rubocop/issues/5314
  config.lookup_paths = config.lookup_paths + %w[
    %<root>s.%<rule>s.%<predicate>s
  ].freeze
  # rubocop:enable Lint/NestedPercentLiteral
end

# @since 0.1.0
module Hanami
  # Validator
  class Validator
    def self.inherited(base)
      super

      base.class_eval do
        @schema = nil
        extend ClassMethods
      end
    end

    # Class level interface
    module ClassMethods
      def validations(type = :schema, &blk)
        t = case type
            when :schema then :Schema
            when :form   then :Params
            when :json   then :JSON
            else
              raise ArgumentError.new("unsupported schema type: #{type.inspect}")
            end

        @schema = Dry::Validation.send(t, &blk)
      end

      attr_reader :schema
    end

    def initialize
      freeze
    end

    def call(input)
      result = self.class.schema.call(input.to_hash)

      if result.success?
        Hanami::Success.new(result.output)
      else
        Hanami::Validations::Failure.new(result.messages, result.output)
      end
    end
  end

  # Hanami::Validations is a set of lightweight validations for Ruby objects.
  #
  # @since 0.1.0
  #
  # @example
  #   require 'hanami/validations'
  #
  #   class Signup < Hanami::Validator
  #     validations do
  #       # ...
  #     end
  #   end
  module Validations
    # Failure
    class Failure < Hanami::Failure
      # Hash
      attr_reader :messages

      def initialize(messages, **data)
        @messages = messages.freeze
        @data     = data.freeze
      end

      def full_messages(error_set = messages)
        error_set.each_with_object([]) do |(key, messages), result|
          k = Utils::String.titleize(key)

          msgs = if messages.is_a?(::Hash)
                   full_messages(messages)
                 else
                   messages.map { |message| "#{k} #{message}" }
                 end

          result.concat(msgs)
        end
      end
    end
  end
end
