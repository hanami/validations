module Hanami
  module Validations
    class MissingMessageError < RuntimeError
      def initialize(validation_type)
        super(":#{ validation_type } has no validation message defined")
      end
    end
  end
end