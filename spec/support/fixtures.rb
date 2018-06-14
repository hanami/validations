# frozen_string_literal: true

require "i18n"
require "dry/validation/messages/i18n"

I18n.load_path.concat(Dir["spec/support/fixtures/i18n/*.yml"])
I18n.backend.load_translations

module SharedPredicates
  include Hanami::Validations::Predicates

  self.messages = :i18n

  predicate :accepted? do |actual|
    actual && actual == true
  end
end

class SignupValidator < Hanami::Validator
  validations do
    configure do
      config.messages_file = "spec/support/fixtures/messages.yml"
    end

    required(:age).filled(:int?, gt?: 18)
  end
end

module Web
  module Controllers
    module Signup
      class Create
        class Params < Hanami::Validator
          validations(:form) do
            configure do
              config.messages_file = "spec/support/fixtures/messages.yml"
            end

            required(:age).filled(:int?, gt?: 18)
          end
        end
      end
    end
  end
end

class DomainValidator < Hanami::Validator
  validations do
    configure do
      config.messages = :i18n
    end

    required(:name).filled(:str?, max_size?: 253)
  end
end

class ChangedTermsOfServicesValidator < Hanami::Validator
  validations(:form) do
    configure do
      predicates(SharedPredicates)
    end

    required(:terms).filled(:bool?, :accepted?)
  end
end
