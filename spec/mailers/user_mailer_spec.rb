require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#price_notification" do
    let(:email) do
      described_class.with(
        user: build_stubbed(:user, email: "test@example.com"),
        tracker: build_stubbed(:tracker, title: "Super Tracker", threshold_price: "1000")
      ).price_drop_notification
    end

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

  describe "#user_contact_submission" do
    let(:email) do
      described_class.user_contact_submission("This is my e-mail's content.", "test@example.com")
    end

    it "should send an e-mail" do
      email.deliver_now

      expect(email.from).to eq ["no-reply@furnitrackr.com"]
      expect(email.to).to eq [ENV["PERSONAL_EMAIL_ADDRESS"]]
      expect(email.subject).to eq "Furnitrackr | New contact submission"
      expect(email.body.include?("This is my e-mail&#39;s content.")).to eq true
      expect(email.body.include?("<strong>Sender:</strong> test@example.com")).to eq true
    end
  end

  describe "#registration_confirmation" do
    let(:user) { create(:user, email: "user@furnitrackr.com", email_confirmation_token: "abcdefghij") }
    let(:email) do
      described_class.registration_confirmation(user)
    end

    it "should send an e-mail" do
      email.deliver_now

      expect(email.from).to eq ["no-reply@furnitrackr.com"]
      expect(email.to).to eq ["user@furnitrackr.com"]
      expect(email.subject).to eq "Furnitrackr | Please confirm your e-mail"
      expect(email.body.include?(confirm_email_url("abcdefghij"))).to eq true
    end
  end
end
