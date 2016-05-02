module TestUtils
  def self.included(base)
    base.class_eval do
      let(:result) { @validator.new(input).validate }
    end
  end
end
