# frozen_string_literal: true

class NotifyUsersService
  def self.call
    Tracker.to_notify.each do |t|
      UserMailer.with(user: t.user, tracker: t).price_drop_notification.deliver_now
    end
  end
end
