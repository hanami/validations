require 'hanami/validations/predicates'
require 'set'

module Hanami
  module Validations
    class Rules
      # FIXME: Inherit from Utils::BasicObject
      class Context
        def initialize(key, actual, rules)
          @key    = key
          @actual = actual
          @rules  = rules
          @errors = Set.new
        end

        def call
          instance_exec(&@rules)
          self
        end

        def errors
          @errors.to_a
        end

        def method_missing(m, *args)
          Predicates.call(m, @actual, *args).tap do |ret|
            next if ret
            @errors << Error.new(@key, m, args.first, @actual)
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

      def initialize(key, rules)
        @key   = key
        @rules = rules
      end

      attr_reader :key

      def call(data)
        Context.new(@key, data.fetch(@key, nil), @rules).call
      end

      def add_prefix(prefix)
        @key = :"#{ prefix }.#{ @key }"
        self
      end
    end
  end
end
