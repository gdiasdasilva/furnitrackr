require 'rails_helper'

RSpec.describe Tracker, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  subject do
    described_class.new(
      title: 'Example title',
      url: 'http://example.com',
      threshold_price: 500,
      user: user,
      product: product,
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a user" do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a product" do
    subject.product = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a url" do
    subject.url = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a threshold_price" do
    subject.threshold_price = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a negative threshold_price" do
    subject.threshold_price = -50
    expect(subject).to_not be_valid
  end

  describe "associations" do
    it { should have_many :prices }
    it { should belong_to :product }
    it { should belong_to :user }
  end

  describe "#fetch_current_price" do
    before do
      stub_request(:get, 'http://example.com')
      allow(FetchPriceFromProviderService).to receive_message_chain(:new, :call).and_return(500)
    end

    it "creates a new price record" do
      expect { subject.fetch_current_price }.to change { Price.count }.by(1)

      expect(Price.last).to have_attributes(
        product: product,
        value: 50000
      )
    end
  end
end
