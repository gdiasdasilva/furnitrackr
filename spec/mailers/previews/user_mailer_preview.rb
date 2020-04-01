class UserMailerPreview < ActionMailer::Preview
  def price_drop_notification
    UserMailer.with(user: User.first, tracker: Tracker.first).price_drop_notification
  end
end
