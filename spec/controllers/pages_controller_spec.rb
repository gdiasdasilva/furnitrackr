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
      let(:params) do
        { email: "furnitrackr@example.com", message: "This is an example message.", math: "5" }
      end

      # TODO: Sending synchronously at the moment to reduce dyno costs
      xit "enqueues sending the email" do
        allow(SendUserContactSubmissionJob).to receive(:perform_later)
        subject
        expect(SendUserContactSubmissionJob).to have_received(:perform_later)
      end

      it "sends the e-mail instantly" do
        expect(UserMailer).to receive_message_chain(:user_contact_submission, :deliver_now)
        subject
      end
    end

    context "when params are incorrect" do
      let(:params) { { message: "This is an example message.", math: "5" } }

      it "shows an error message" do
        subject
        expect(flash[:error]).to eq "Could not submit your message. Please try again later."
      end
    end
  end
end
