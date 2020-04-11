require "rails_helper"

RSpec.describe SendUserContactSubmissionJob, type: :job do
  describe "#perform" do
    let(:message) { "I am a special testing message." }
    let(:email_address) { "example@furnitrackr.com" }

    it "calls the UserMailer" do
      allow(UserMailer).to receive_message_chain(:user_contact_submission, :deliver_now)

      described_class.new.perform(message, email_address)

      expect(UserMailer).to have_received(:user_contact_submission)
    end
  end

  describe ".perform_later" do
    it "adds the job to the queue :user_contact_submissions" do
      allow(UserMailer).to receive_message_chain(:with, :user_contact_submission, :deliver_now)

      described_class.perform_later(1)

      expect(enqueued_jobs.last[:job]).to eq described_class
    end
  end
end
