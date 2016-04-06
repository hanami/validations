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

      def initialize(name = nil)
        @name  = name
        @rules = []
      end

      def add(rules)
        if rules.is_a?(self.class)
          rules.rules.each { |rule| add(rule.add_prefix(rules.name)) }
        else
          @rules << rules
        end
      end

      def call(data)
        Result.new(_call(data))
      end

      protected

      def _call(data)
        @rules.each_with_object({}) do |rules, result|
          errors = rules.call(data).errors
          result[rules.key] = errors unless errors.empty?
        end
      end
    end
  end
end
