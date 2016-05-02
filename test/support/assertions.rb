require 'minitest/assertions'

module Minitest
  module Assertions
    def assert_successful(result, key = :foo)
      assert result.success?, "Expected #{result.inspect} to be successful"
      assert result.messages.fetch(key, []).empty?, "Expected #{result.messages[key]} to be empty"
    end

    def refute_successful(result, messages, key = :foo)
      refute       result.success?, "Expected #{result.inspect} to NOT be successful"
      assert_equal messages, result.messages.fetch(key)
    end
  end
end
