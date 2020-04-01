require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:email) do
    described_class.with(
      user: build_stubbed(:user, email: "test@example.com"),
      tracker: build_stubbed(:tracker, title: "Super Tracker", threshold_price: "1000")
    ).price_drop_notification
  end

  describe "#price_notification" do
    it "should send an e-mail" do
      email.deliver_now

      expect(email.from).to eq ["no-reply@furnitrackr.com"]
      expect(email.to).to eq ["test@example.com"]
      expect(email.subject).to eq "Furnitrackr | Price has dropped!"
      expect(
        email.body.include?("The price for <strong>Super Tracker</strong> has dropped below 10.00€")
      ).to eq true
    end
  end
end
