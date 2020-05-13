require "rails_helper"

describe UsersController do
  describe "#create" do
    context "with valid attributes" do
      it "creates user and sends confirmation email" do
        post :create, params: { user: { email: "user@example.com", password: "password" } }

        expect(User.last.email_confirmation_token).to be_present

        expect(ActionMailer::Base.deliveries).not_to be_empty
        email = ActionMailer::Base.deliveries.last

        expect(email.to).to eq ["user@example.com"]
        expect(email.subject).to eq "Furnitrackr | Please confirm your e-mail"
      end
    end
  end
end
