require 'test_helper'

describe Hanami::Validations::VERSION do
  it 'exposes version' do
    Hanami::Validations::VERSION.must_equal '0.5.0'
  end
end
