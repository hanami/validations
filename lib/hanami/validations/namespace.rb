require 'hanami/utils/string'

module Hanami
  module Validations
    # Validations message namespace.
    #
    # For a given `FooValidator` class, it will look for I18n messages within
    # the `foo` group.
    #
    # @since x.x.x
    # @api private
    class Namespace
      # @since x.x.x
      # @api private
      SUFFIX = 'Validator'.freeze

      # @since x.x.x
      # @api private
      SUFFIX_REPLACEMENT = ''.freeze

      # @since x.x.x
      # @api private
      RUBY_NAMESPACE_SEPARATOR = '/'.freeze

      # @since x.x.x
      # @api private
      RUBY_NAMESPACE_REPLACEMENT = '.'.freeze

      # @since x.x.x
      # @api private
      def self.new(name, klass)
        result = name || klass.name
        return nil if result.nil?

        super(result)
      end

      # @since x.x.x
      # @api private
      def initialize(name)
        @name = name
      end

      # @since x.x.x
      # @api private
      def to_s
        underscored_name.gsub(RUBY_NAMESPACE_SEPARATOR, RUBY_NAMESPACE_REPLACEMENT)
      end

      private

      # @since x.x.x
      # @api private
      def underscored_name
        Utils::String.new(name_without_suffix).underscore
      end

      # @since x.x.x
      # @api private
      def name_without_suffix
        @name.sub(SUFFIX, SUFFIX_REPLACEMENT)
      end
    end
  end
end
