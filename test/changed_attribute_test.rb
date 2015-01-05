require 'test_helper'

describe Lotus::Validations do
  it 'revalidates when attribute values change' do
    validator = PresenceValidatorTest.new(name: nil, age: '1')
    validator.valid?.must_equal false
    validator.name = 'a'
    validator.valid?.must_equal true
  end
end