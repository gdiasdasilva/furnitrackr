require "rails_helper"

describe User do
  describe "#confirm_email" do
    let(:user) { create(:user, email_confirmation_token: "token", email_confirmed_at: nil) }

    it "sets email_confirmed_at value" do
      user.confirm_email
      expect(user.email_confirmed_at).to be_present
    end
  end
end
