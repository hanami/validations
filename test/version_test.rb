require 'test_helper'

describe Hanami::Validations::VERSION do
  it 'exposes version' do
    Hanami::Validations::VERSION.must_equal '1.0.0.rc1'
  end
end
