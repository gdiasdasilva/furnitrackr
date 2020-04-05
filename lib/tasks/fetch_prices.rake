# frozen_string_literal: true

desc "Fetch prices for all trackers in the app"
task fetch_prices: :environment do
  trackers_processed = []
  trackers_to_notify = []
  trackers_not_processed = []

  trackers = Tracker.enabled

  puts "Running for #{trackers.count} trackers..."

  trackers.each do |t|
    price = t.fetch_current_price

    if price.blank?
      trackers_not_processed << t
      next
    end

    trackers_processed << t

    if price.value <= t.threshold_price
      trackers_to_notify << t
    end
  end

  trackers_to_notify.each do |t|
    UserMailer.with(user: t.user, tracker: t).price_drop_notification.deliver_now
  end

  puts "\n"
  puts "-------------------------------"
  puts "Processing SUCCESS: #{trackers_processed.map(&:id)}"
  puts "Processing ERROR: #{trackers_not_processed.map(&:id)}"
  puts "\n"
  puts "Notified: #{trackers_to_notify.map(&:id)}"
  puts "-------------------------------"
  puts "\n"

  puts "Finished processing!"
end
