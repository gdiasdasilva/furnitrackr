# frozen_string_literal: true

desc "Fetch prices for all trackers in the app"
task fetch_prices: :environment do
  @trackers_processed = []
  @trackers_to_notify = []
  @trackers_not_processed = []

  Tracker.enabled.each do |t|
    price = t.fetch_current_price

    if price.blank?
      @trackers_not_processed << t
      next
    end

    @trackers_processed << t

    if price.value <= t.threshold_price
      @trackers_to_notify << t
    end
  end

  puts "Processed: #{@trackers_processed.map(&:id)}"
  puts "Not processed: #{@trackers_not_processed.map(&:id)}"

  @trackers_to_notify.each do |t|
    puts "User '#{t.user.email}' should be notified for " \
        "'#{t.title}' because #{t.prices.order(:created_at).last.value} <= #{t.threshold_price}"
  end
end
