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

    context "when price cannot be fetched due to request failure" do
      before do
        stub_request(:get, "http://example.com").to_return(status: 404)
      end

      it "returns an error and notifies Bugsnag" do
        expect(Bugsnag).to receive(:notify)

        expect { subject.fetch_current_price }.not_to change(Price, :count)
        expect(subject.errors.full_messages.first).to eq "Could not fetch price from product URL."
      end
    end

    context "when price is not found on page" do
      before do
        stub_request(:get, "http://example.com")
      end

      it "returns an error message" do
        allow(FetchPriceFromProviderService).to receive_message_chain(:new, :call).and_return(nil)
        expect { subject.fetch_current_price }.not_to change(Price, :count)
        expect(subject.errors.full_messages.first).to eq "Could not fetch price from product URL."
      end
    end

    context "when a price already exists for the current day" do
      before do
        travel_to Time.new(2020, 3, 2, 12)
      end

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

  describe "#last_fetched_price" do
    let!(:price) { create(:price, product: product, created_at: 1.day.ago) }

    before do
      create(:price, product: product, created_at: 3.days.ago)
      create(:price, product: product, created_at: 4.days.ago)
    end

    it "returns the most recent price" do
      expect(subject.last_fetched_price.id).to eq price.id
    end
  end

  describe "#price_changed?" do
    context "when last 2 prices values are equal" do
      before do
        create(:price, product: subject.product, value: 100, created_at: 3.days.ago)
        create(:price, product: subject.product, value: 99, created_at: 2.days.ago)
        create(:price, product: subject.product, value: 99, created_at: 1.day.ago)
      end

      it "returns false" do
        expect(subject.price_changed?).to eq false
      end
    end

    context "when last 2 prices values are different" do
      before do
        create(:price, product: subject.product, value: 99, created_at: 3.days.ago)
        create(:price, product: subject.product, value: 100, created_at: 2.days.ago)
        create(:price, product: subject.product, value: 99, created_at: 1.day.ago)
      end

      it "returns true" do
        expect(subject.price_changed?).to eq true
      end
    end
  end

  describe ".to_notify" do
    context "when multiple trackers exists" do
      let(:tracker_1) { create(:tracker, threshold_price: 500) }
      let(:tracker_2) { create(:tracker, threshold_price: 600) }
      let(:tracker_3) { create(:tracker, threshold_price: 700) }
      let(:tracker_4) { create(:tracker, threshold_price: 700) }
      let(:tracker_5) { create(:tracker, threshold_price: 700) }

      before do
        create(:price, value: 499, product: tracker_1.product)
        create(:price, value: 599, product: tracker_2.product)
        create(:price, value: 700, product: tracker_3.product, created_at: 2.days.ago)
        create(:price, value: 701, product: tracker_3.product)
        create(:price, value: 701, product: tracker_4.product)
        create(:price, value: 701, product: tracker_5.product)
        create(:price, value: 700, product: tracker_5.product)
      end

      it "returns trackers with last price below threshold value" do
        trackers = described_class.to_notify
        expect(trackers.pluck(:id)).to match_array [tracker_1.id, tracker_2.id, tracker_5.id]
      end
    end

    context "when price is the same as before" do
      let(:tracker) { create(:tracker, threshold_price: 600) }

      before do
        allow_any_instance_of(Tracker).to receive(:price_changed?).and_return(false)
      end

      before do
        create(:price, value: 400, product: tracker.product, created_at: 3.days.ago)
        create(:price, value: 599, product: tracker.product, created_at: 2.days.ago)
        create(:price, value: 599, product: tracker.product, created_at: 1.day.ago)
      end

      it "does not include tracker" do
        expect(described_class.to_notify.pluck(:id)).to eq []
      end
    end
  end
end
