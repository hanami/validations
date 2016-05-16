module Hanami
  module Validations
    class Namespace
      SUFFIX = 'Validator'.freeze
      SUFFIX_REPLACEMENT = ''.freeze

      RUBY_NAMESPACE_SEPARATOR   = '/'.freeze
      RUBY_NAMESPACE_REPLACEMENT = '.'.freeze

      def self.new(name, klass)
        result = name || klass.name
        return nil if result.nil?

        super(result)
      end

      def initialize(name)
        @name = name
      end

      def to_s
        underscored_name.gsub(RUBY_NAMESPACE_SEPARATOR, RUBY_NAMESPACE_REPLACEMENT)
      end

      private

      def underscored_name
        Utils::String.new(name_without_suffix).underscore
      end

      def name_without_suffix
        @name.sub(SUFFIX, SUFFIX_REPLACEMENT)
      end
    end
  end
end
