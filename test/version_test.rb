require 'test_helper'

describe Lotus::Validations::VERSION do
  it 'exposes version' do
    Lotus::Validations::VERSION.must_equal '0.2.1.dev'
  end
end
