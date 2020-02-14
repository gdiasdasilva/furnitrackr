require 'rails_helper'

RSpec.describe Price, type: :model do
  subject do
    described_class.new(
      product: create(:product),
      value: 500,
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a product" do
    subject.product = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without value" do
    subject.value = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with value < 1" do
    subject.value = 0
    expect(subject).to_not be_valid
  end

  describe "associations" do
    it { should belong_to :product }
  end
end
