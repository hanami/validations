require 'hanami/validations/predicates'
require 'set'

module Hanami
  module Validations
    class Rules
      require 'hanami/utils/basic_object'
      class Context < Utils::BasicObject
        def initialize(key, actual, rules)
          @key    = key
          @actual = actual
          @rules  = rules
          @errors = ::Set.new
        end

        def call
          instance_exec(&@rules)
          self
        end

        def errors
          @errors.to_a
        end

        def size?(size)
          predicate = ::Hanami::Validations::Predicates.predicate(:size?)
          predicate.call(@actual, size).tap do |ret|
            break if ret
            @errors << ::Hanami::Validations::Rules::Error.new(@key, :size?, size, @actual.size)
          end
        end

        def method_missing(m, *args, &blk)
          predicate = ::Hanami::Validations::Predicates.predicate(m)
          predicate.call(@actual, *args, &blk).tap do |ret|
            break if ret
            @errors << ::Hanami::Validations::Rules::Error.new(@key, m, args.first, @actual)
          end
        end
      end

      class Error
        attr_reader :key, :predicate, :expected, :actual

        def initialize(key, predicate, expected, actual)
          @key       = key
          @predicate = predicate
          @expected  = expected
          @actual    = actual
        end

        def ==(other)
          key == other.key &&
            predicate == other.predicate &&
            expected  == other.expected &&
            actual    == other.actual
        end
      end

      PREFIX_SEPARATOR = '.'.freeze

      def initialize(key, rules)
        @key   = key
        @rules = rules
      end

      attr_reader :key

      def call(data)
        Context.new(@key, dig(data), @rules).call
      end

      def add_prefix(prefix)
        @key = :"#{ prefix }#{ PREFIX_SEPARATOR }#{ @key }"
        self
      end

      private

      def dig(data)
        key, *keys = @key.to_s.split(PREFIX_SEPARATOR)
        result     = data.fetch(key.to_sym, nil)

        Array(keys).each do |k|
          break if result.nil?
          result = result.fetch(k.to_sym, nil)
        end

        result
      end
    end
  end
end
