require 'rails_helper'

RSpec.describe Product, type: :model do
  subject do
    described_class.new(
      provider_identifier: "example-identifier",
      provider: :ikea,
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a provider identifier" do
    subject.provider_identifier = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a provider" do
    subject.provider = nil
    expect(subject).to_not be_valid
  end

  describe "providers enum" do
    it {
      should define_enum_for(:provider).with_values(ikea: 0).backed_by_column_of_type(:integer)
    }
  end

  describe "associations" do
    it { should have_many :trackers }
    it { should have_many :prices }
  end
end
