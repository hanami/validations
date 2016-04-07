require 'hanami/utils/basic_object'
require 'hanami/validations/predicates'
require 'hanami/validations/error'
require 'set'

module Hanami
  module Validations
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

      def type?(type)
        result = ::Hanami::Validations::Predicates.predicate(:type?).call(@actual, type)

        if result.success?
          @actual = result.value
        else
          @errors << ::Hanami::Validations::Error.new(@key, :type?, type, @actual)
        end
      end

      def size?(size)
        predicate = ::Hanami::Validations::Predicates.predicate(:size?)
        predicate.call(@actual, size).tap do |ret|
          unless ret
            @errors << ::Hanami::Validations::Error.new(@key, :size?, size, @actual.size)
          end
        end
      end

      def method_missing(m, *args, &blk)
        predicate = ::Hanami::Validations::Predicates.predicate(m)
        predicate.call(@actual, *args, &blk).tap do |ret|
          unless ret
            @errors << ::Hanami::Validations::Error.new(@key, m, args.first, @actual)
          end
        end
      end
    end
  end
end
