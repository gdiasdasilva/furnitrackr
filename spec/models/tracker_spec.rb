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

  describe "validations" do
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
  end

  describe "associations" do
    it { should have_many :prices }
    it { should belong_to :product }
    it { should belong_to :user }
  end

  describe "callbacks" do
    describe "#cleanup_url" do
      it "removes query params from the url" do
        subject.url = "https://example.com/my-product/oh-no?foo=bar&baz=fly"
        subject.save

        expect(subject.url).to eq "https://example.com/my-product/oh-no"
      end
    end
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

    context "when a price already exists for the current day" do
      let!(:price_1) { create(:price, product: product, created_at: 3.hours.ago) }
      let!(:price_2) { create(:price, product: product, created_at: 4.hours.ago) }

      it "returns the last fetched price" do
        expect(subject.fetch_current_price.id).to eq price_1.id
      end
    end
  end

  describe "#display_price_euros" do
    it "returns the price in euros with symbol" do
      expect(subject.display_price_euros).to eq "5.00€"
    end
  end
end
