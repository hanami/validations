require 'test_helper'

describe Lotus::Validations::Errors do
  before do
    @errors = Lotus::Validations::Errors.new
  end

  describe '#initialize' do
    it 'is empty by default' do
      @errors.must_be_empty
    end
  end

  describe '#add' do
    it 'adds an error for an attribute' do
      @errors.add(:email, Lotus::Validations::Error.new(:email, :format, /@/, 'test'))
      @errors.wont_be_empty
    end
  end

  describe '#for' do
    it 'returns errors for the given attribute' do
      @errors.add(:email, Lotus::Validations::Error.new(:email, :format, /@/, 'test'))
      @errors.add(:name,  Lotus::Validations::Error.new(:name, :presence, true, nil))

      @errors.for(:name).must_include Lotus::Validations::Error.new(:name, :presence, true, nil)
    end
  end

  describe '#each' do
    it 'yields the given block for each error' do
      result = []

      @errors.add(:email,
        Lotus::Validations::Error.new(:email, :format, /@/, 'test'),
        Lotus::Validations::Error.new(:email, :confirmation, true, 'test')
      )

      @errors.add(:name,
        Lotus::Validations::Error.new(:name, :presence, true, nil)
      )

      @errors.each do |error|
        result << (
          "%{attribute} must match %{validation} (expected %{expected}, was %{actual})" %
          {attribute: error.attribute, validation: error.validation, expected: error.expected, actual: error.actual}
        )
      end

      result.must_equal [
        "email must match format (expected (?-mix:@), was test)",
        "email must match confirmation (expected true, was test)",
        "name must match presence (expected true, was )",
      ]
    end
  end

  describe '#map' do
    it 'yields the given block for each error' do
      @errors.add(:email,
        Lotus::Validations::Error.new(:email, :format, /@/, 'test'),
        Lotus::Validations::Error.new(:email, :confirmation, true, 'test')
      )

      @errors.add(:name,
        Lotus::Validations::Error.new(:name, :presence, true, nil)
      )

      result = @errors.map do |error|
        "%{attribute} must match %{validation} (expected %{expected}, was %{actual})" %
          {attribute: error.attribute, validation: error.validation, expected: error.expected, actual: error.actual}
      end

      result.must_equal [
        "email must match format (expected (?-mix:@), was test)",
        "email must match confirmation (expected true, was test)",
        "name must match presence (expected true, was )",
      ]
    end
  end

  describe '#count' do
    before do
      @errors.add(:email,
        Lotus::Validations::Error.new(:email, :format, /@/, 'test'),
        Lotus::Validations::Error.new(:email, :confirmation, true, 'test')
      )

      @errors.add(:name,
        Lotus::Validations::Error.new(:name, :presence, true, nil)
      )
    end

    it 'returns the count of errors' do
      @errors.count.must_equal 3
    end

    it 'is aliased as size' do
      @errors.size.must_equal 3
    end
  end

  describe '#==' do
    it 'compares with other errors' do
      assert Lotus::Validations::Errors.new == Lotus::Validations::Errors.new
    end
  end
end

