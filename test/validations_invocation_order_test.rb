require 'test_helper'

describe Hanami::Validations do
  describe 'validations invocation order' do
    it 'is the same as its declaration order' do
      ValidationsOrderTest.validation_index(:name, :presence).must_equal 0
      ValidationsOrderTest.validation_index(:name, :size).must_equal 1
      ValidationsOrderTest.validation_index(:last_name, :case).must_equal 2
      ValidationsOrderTest.validation_index(:last_name, :size).must_equal 3
      ValidationsOrderTest.validation_index(:last_name, :presence).must_equal 4
      ValidationsOrderTest.validation_index(:name, :inclusion).must_equal 5
    end
  end
end