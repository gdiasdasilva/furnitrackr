# frozen_string_literal: true

desc "Send e-mails to users that must be notified due to price drops"
task notify_users: :environment do
  puts "Notifying users ..."
  NotifyUsersService.call
  puts "Done!"
end
