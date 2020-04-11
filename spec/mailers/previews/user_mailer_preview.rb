class UserMailerPreview < ActionMailer::Preview
  def price_drop_notification
    UserMailer.with(user: User.first, tracker: Tracker.first).price_drop_notification
  end

  def user_contact_submission
    message = "<p style=\"color: red;\">Hi, my name is Ringo and I want to report a bug.</p>"
    UserMailer.with(message: message, email: "example@furnitrackr.com").user_contact_submission
  end
end
