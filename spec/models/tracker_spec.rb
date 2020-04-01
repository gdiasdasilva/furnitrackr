require "rails_helper"

RSpec.describe Tracker, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  subject do
    described_class.new(
      title: "Example title",
      url: "http://example.com",
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
      stub_request(:get, "http://example.com")
    end

    it "creates a new price record" do
      allow(FetchPriceFromProviderService).to receive_message_chain(:new, :call).and_return(500)
      expect { subject.fetch_current_price }.to change(Price, :count).by(1)

      expect(Price.last).to have_attributes(
        product: product,
        value: 50000
      )
    end

    context "when price cannot be fetched" do
      before do
        stub_request(:get, "http://example.com").to_return(status: 404)
      end

      it "returns an error and notifies Bugsnag" do
        expect(Bugsnag).to receive(:notify)

        expect { subject.fetch_current_price }.not_to change(Price, :count)
        expect(subject.errors.full_messages.first).to eq "Could not fetch price from product URL."
      end
    end
  end

  describe "#display_price_euros" do
    it "returns the price in euros with symbol" do
      expect(subject.display_price_euros).to eq "5.00€"
    end
  end
end
