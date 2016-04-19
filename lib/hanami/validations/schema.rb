require 'hanami/validations/rules'
require 'hanami/validations/predicates'
require 'hanami/validations/prefix'
require 'hanami/validations/input'
require 'hanami/validations/output'
require 'hanami/validations/errors'

module Hanami
  module Validations
    class Schema
      class Result
        attr_reader :output, :errors

        def initialize(output, errors)
          @output = output.to_h
          @errors = errors
        end

        def success?
          @errors.empty?
        end
      end

      class Proxy
        def initialize(schema, name)
          @schema = schema
          @name   = name
        end

        def with(validator)
          @schema.group(@name, validator.schema)
        end
      end

      attr_reader :name, :rules

      def initialize(name = nil, predicates = {}, &blk)
        @name       = name
        @predicates = predicates
        @groups     = []
        @rules      = []
        instance_eval(&blk) if block_given?
      end

      def initialize_copy(original)
        @predicates = original.instance_variable_get(:@predicates).dup
        @groups     = original.instance_variable_get(:@groups).dup
        @rules      = original.instance_variable_get(:@rules).dup
      end

      def validates(name, &blk)
        if blk
          add Rules.new(name.to_sym, blk)
        else
          Proxy.new(self, name)
        end
      end

      def key(name)
        add Rules.new(name.to_sym, -> { true })
      end

      def group(name, schema = nil, &blk)
        @groups << if schema.nil?
                     self.class.new(_prefixed(name), @predicates.dup, &blk)
                   else
                     schema.duplicated(name)
                   end
      end

      def predicate(name, &blk)
        @predicates[name] = Predicates.fabricate(name, blk)
      end

      def add(rules)
        @rules << rules
      end

      def call(input, output = nil)
        Result.new(*_call(input, output))
      end

      protected

      def name=(value)
        @name = value
        @groups.each do |group|
          group.name = Prefix.join(value, group.name)
        end
      end

      def duplicated(name)
        schema = dup
        schema.name = name
        schema
      end

      def _call(input, output)
        input    = Input.new(input)
        output ||= Output.new
        _run_groups(input, output,
                    _run_rules(input, output))
      end

      def _run_rules(input, output)
        @rules.each_with_object(Errors.new) do |rules, result|
          errors = rules.call(input, output, @name, @predicates).errors
          result.set(_prefixed(rules.key), errors)
        end
      end

      def _run_groups(input, output, errors)
        @groups.each do |group|
          errors.merge!(
            group.call(input, output).errors
          )
        end

        [output, errors]
      end

      def _prefixed(key)
        Prefix.join(@name, key)
      end
    end
  end
end
