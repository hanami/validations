require 'hanami/validations/rules'
require 'hanami/validations/predicates'
require 'hanami/validations/prefix'

module Hanami
  module Validations
    class Schema
      class Result
        attr_reader :output, :errors

        def initialize(output, errors)
          @output = output
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

      def call(data, output = nil)
        Result.new(*_call(data, output))
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

      def _call(data, output)
        output ||= Hash.new { |h,k| h[k] = {} }
        _run_groups(data, output,
                    _run_rules(data, output))
      end

      def _run_rules(data, output)
        @rules.each_with_object({}) do |rules, result|
          errors = rules.call(data, output, @name, @predicates).errors
          result[_prefixed(rules.key)] = errors unless errors.empty?
        end
      end

      def _run_groups(data, output, errors)
        @groups.each do |group|
          errors.merge!(
            group.call(data, output).errors
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
