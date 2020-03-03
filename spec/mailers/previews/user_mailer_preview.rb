class UserMailerPreview < ActionMailer::Preview
  def price_notification
    UserMailer.with(user: User.first, tracker: Tracker.first).price_notification
  end
end
