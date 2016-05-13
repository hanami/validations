class SignupValidator
  include Hanami::Validations
  messages 'test/fixtures/messages.yml'

  validations do
    required(:age).filled(:int?, gt?: 18)
  end
end

module Web
  module Controllers
    module Signup
      class Create
        class Params
          include Hanami::Validations::Form
          messages 'test/fixtures/messages.yml'

          validations do
            required(:age).filled(:int?, gt?: 18)
          end
        end
      end
    end
  end
end
