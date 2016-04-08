require 'hanami/validations/rules'
require 'hanami/validations/predicates'

module Hanami
  module Validations
    class Schema
      class Result
        attr_reader :errors

        def initialize(errors)
          @errors = errors
        end

        def success?
          @errors.empty?
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

      def validates(name, &blk)
        add Validations::Rules.new(name.to_sym, blk)
      end

      def group(group_name, &blk)
        @groups << self.class.new(_prefixed(group_name), @predicates.dup, &blk)
      end

      def predicate(name, &blk)
        @predicates[name] = Predicates.fabricate(name, blk)
      end

      def add(rules)
        @rules << rules
      end

      def call(data)
        Result.new(_call(data))
      end

      protected

      def _call(data)
        _run_groups(data,
                    _run_rules(data))
      end

      def _run_rules(data)
        @rules.each_with_object({}) do |rules, result|
          errors = rules.call(data, @name, @predicates).errors
          result[_prefixed(rules.key)] = errors unless errors.empty?
        end
      end

      def _run_groups(data, errors)
        @groups.each do |group|
          errors.merge!(
            group.call(data).errors
          )
        end

        errors
      end

      def _prefixed(key)
        [@name, key].compact.join('.').to_sym
      end
    end
  end
end
