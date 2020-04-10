# frozen_string_literal: true

desc "Fetch prices for all trackers in the app"
task fetch_prices: :environment do
  puts "Fetching prices ..."
  Tracker.enabled.each(&:fetch_current_price)
  puts "Done!"
end
