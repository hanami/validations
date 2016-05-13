require 'dry/logic/predicates'
require 'hanami/utils/class_attribute'

module Hanami
  module Validations
    module Predicates
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
