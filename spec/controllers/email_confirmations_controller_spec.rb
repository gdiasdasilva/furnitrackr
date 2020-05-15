require "rails_helper"

describe EmailConfirmationsController do
  describe "#update" do
    context "with invalid email confirmation token" do
      it "raises RecordNotFound exception" do
        expect do
          get :update, params: { token: "inexistent" }
        end.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context "with valid confirmation token" do
      let!(:user) { create(:user, :unconfirmed, email_confirmation_token: "valid_token") }

      it "confirms user and signs it in" do
        get :update, params: { token: "valid_token" }

        user.reload
        expect(user.email_confirmed_at).to be_present
        expect(response).to redirect_to(trackers_path)
        expect(flash[:success]).to eq "Your e-mail was confirmed. You're all set!"
      end
    end
  end
end
