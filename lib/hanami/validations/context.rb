require 'hanami/utils/basic_object'
require 'hanami/validations/predicates'
require 'hanami/validations/error'
require 'hanami/validations/prefix'
require 'set'

module Hanami
  module Validations
    class UnknownPredicateError < ::StandardError
      def initialize(name)
        super("Unknown predicate: `#{ name }'")
      end
    end

    class Context #< Utils::BasicObject
      def initialize(key, data, output, rules, predicates)
        @key        = key
        @data       = data
        @output     = output
        @actual     = val(key)
        @rules      = rules
        @predicates = predicates
        @errors     = ::Set.new
      end

      def call
        result = instance_exec(&@rules)
        _set!
        _add_generic_error!(result)
        self
      end

      def errors
        @errors.to_a
      end

      def array?
        _type?(Array)
      end

      def accepted?
        _call(:accepted?, @actual) { _error(:accepted?, true, @actual) }
      end

      def all?(&blk)
        _predicate(:all?).call(@actual, &blk) or _error(:all?, nil, @actual)
      end

      def any?(&blk)
        _predicate(:any?).call(@actual, &blk) or _error(:any?, nil, @actual)
      end

      def bool?
        _type?(Boolean)
      end

      def confirmed?
        confirmation = val(:"#{ @key }_confirmation")
        _call(:confirmed?, @actual, confirmation) { _error(:confirmed?, @actual, confirmation) }
      end

      def date?
        _type?(Date)
      end

      def datetime?
        _type?(DateTime)
      end

      def decimal?
        _type?(BigDecimal)
      end

      def empty?
        _call(:empty?, @actual) { _error(:empty?, nil, @actual) }
      end

      def eql?(expected)
        _call(:eql?, @actual, expected) { _error(:eql?, expected, @actual) }
      end

      def exclusion?(expected)
        _call(:exclusion?, @actual, expected) { _error(:exclusion?, expected, @actual) }
      end

      def filled?
        _call(:filled?, @actual) { _error(:filled?, nil, @actual) }
      end

      def float?
        _type?(Float)
      end

      def format?(expected)
        _call(:format?, @actual, expected) { _error(:format?, expected, @actual) }
      end

      def gt?(expected)
        _call(:gt?, @actual, expected) { _error(:gt?, expected, @actual) }
      end

      def gteq?(expected)
        _call(:gteq?, @actual, expected) { _error(:gteq?, expected, @actual) }
      end

      def hash?
        _type?(Hash)
      end

      def inclusion?(expected)
        _call(:inclusion?, @actual, expected) { _error(:inclusion?, expected, @actual) }
      end

      def int?
        _type?(Integer)
      end

      def lt?(expected)
        _call(:lt?, @actual, expected) { _error(:lt?, expected, @actual) }
      end

      def lteq?(expected)
        _call(:lteq?, @actual, expected) { _error(:lteq?, expected, @actual) }
      end

      def nil?
        _call(:nil?, @actual) { _error(:nil?, nil, @actual) }
      end

      def present?
        _call(:present?, @actual) { _error(:present?, nil, @actual) }
      end

      def size?(expected)
        _call(:size?, @actual, expected) { _error(:size?, expected, @actual.size) }
      end

      def str?
        _type?(String)
      end

      def time?
        _type?(Time)
      end

      def type?(expected)
        _type?(expected)
      end

      def val(key)
        key, *keys = ::Hanami::Validations::Prefix.split(key)
        result     = _fetch(@data, key)

        ::Kernel.Array(keys).each do |k|
          break if result.nil?
          result = _fetch(result, k)
        end

        result
      end

      def value
        @actual
      end

      def method_missing(m, *args, &blk)
        if blk
          _predicate(m).call(@actual, *args, &blk) or _error(m, *args, @actual)
        else
          _call(m, @actual, *args) { _error(m, args.first, @actual) }
        end
      end

      protected

      def _call(predicate, *args)
        _predicate(predicate).call(*args).tap do |result|
          yield unless result
        end
      end

      def _error(predicate, expected, actual)
        @errors << ::Hanami::Validations::Error.new(@key, predicate, expected, actual)
      end

      def _type?(expected)
        result = _predicate(:type?).call(@actual, expected)

        if result.success?
          @actual = result.value
          true
        else
          _error(:type?, expected, @actual)
          false
        end
      end

      def _set!
        h           = @output
        *keys, last = ::Hanami::Validations::Prefix.split(@key)
        keys.each do |k|
          h = h[k]
        end

        h[last] = @actual
      end

      def _add_generic_error!(result)
        if @errors.empty? && (result == false || result.nil?)
          _error(:base, nil, result)
        end
      end

      def _predicate(name)
        ::Hanami::Validations::Predicates.predicate(name) ||
          @predicates.fetch(name) do
            ::Kernel.raise ::Hanami::Validations::UnknownPredicateError.new(name)
          end
      end

      def _fetch(data, key)
        data.fetch(key) do
          data.fetch(key.to_s, nil)
        end
      end
    end
  end
end
