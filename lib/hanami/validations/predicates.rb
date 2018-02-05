require 'dry/logic/predicates'
require 'hanami/utils/class_attribute'

module Hanami
  module Validations
    # Mixin to include when defining shared predicates
    #
    # @since 0.6.0
    #
    # @see Hanami::Validations::ClassMethods#predicates
    #
    # @example Inline Predicate
    #   require 'hanami/validations'
    #
    #   module MySharedPredicates
    #     include Hanami::Validations::Predicates
    #
    #     predicate :foo? do |actual|
    #       actual == 'foo'
    #     end
    #   end
    #
    #   class MyValidator
    #     include Hanami::Validations
    #     predicates MySharedPredicates
    #
    #     validations do
    #       required(:name).filled(:foo?)
    #     end
    #   end
    module Predicates
      # @since 0.6.0
      # @api private
      def self.included(base)
        base.class_eval do
          include Dry::Logic::Predicates
          include Utils::ClassAttribute

          class_attribute :messages
          class_attribute :messages_path
        end
      end
    end
  end
end
