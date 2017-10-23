module RSpec
  module Support
    module Assertions
      def expect_successful(result, key = :foo)
        expect(result).to be_success
        expect(result.messages.fetch(key, [])).to be_empty
      end

      def expect_not_successful(result, messages, key = :foo)
        expect(result).not_to be_success
        expect(messages).to eq(result.messages.fetch(key))
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Support::Assertions
end
