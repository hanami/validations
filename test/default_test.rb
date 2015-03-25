require 'test_helper'

describe Lotus::Validations do
  describe '.default'do
    before do
      class Character
        include Lotus::Validations

        attribute :name, type: String, presence: true, default: 1
        attribute :race, presence: true
        attribute :age, type: Integer
        attribute :level, default: 1
      end
    end

    it 'returns default value' do
      c = Character.new(name: 'Lotus', race: 'asd')
      c.level.must_equal 1
    end

    it "returns nil if default value it doesn't set" do
      c = Character.new(name: 'Lotus', race: 'asd')
      c.age.must_be_nil
    end

    it "default value coerces to type" do
      c = Character.new(race: 'asd')
      c.name.must_equal "1"
    end
  end
end