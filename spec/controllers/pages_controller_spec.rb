require "rails_helper"

RSpec.describe PagesController do
  describe "GET homepage" do
    it "renders the homepage template" do
      get :homepage
      expect(response).to render_template("homepage")
    end
  end

  describe "GET how_does_it_work" do
    it "renders the how_does_it_work template" do
      get :how_does_it_work
      expect(response).to render_template("how_does_it_work")
    end
  end

  describe "GET contact_us" do
    it "renders the contact_us template" do
      get :contact_us
      expect(response).to render_template("contact_us")
    end
  end

  describe "POST send_contact" do
    subject { post :send_contact, params: params }

    context "when params are correct" do
      let(:params) { { email: "furnitrackr@example.com", message: "This is an example message." } }

      it "sends an e-mail" do
        double_mailer = double("user mailer")
        expect(UserMailer).to receive(:with).
          with(email: "furnitrackr@example.com", message: "This is an example message.").
          and_return(double_mailer)
        expect(double_mailer).to receive_message_chain(:user_contact_submission, :deliver_now)

        subject
        expect(flash[:success]).to eq "Your message was successfully submitted."
      end
    end

    context "when params are incorrect" do
      let(:params) { { message: "This is an example message." } }

      it "shows an error message" do
        subject
        expect(flash[:error]).to eq "Could not submit your message. Please try again later."
      end
    end
  end
end
