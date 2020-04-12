class SendUserContactSubmissionJob < ApplicationJob
  queue_as :user_contact_submissions

  def perform(message, email_address)
    UserMailer.user_contact_submission(message, email_address).deliver_now
  end
end
