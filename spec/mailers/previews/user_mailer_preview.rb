class UserMailerPreview < ActionMailer::Preview
  def price_drop_notification
    UserMailer.with(user: User.first, tracker: Tracker.first).price_drop_notification
  end

  def user_contact_submission
    message = "<p style=\"color: red;\">Hi, my name is Ringo and I want to report a bug.</p>"
    UserMailer.user_contact_submission(message, "example@furnitrackr.com")
  end

  def registration_confirmation
    UserMailer.registration_confirmation(User.first)
  end
end
