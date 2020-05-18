# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:setup" do
      user = User.create!(email: "goncalo@furnitrackr.com", password: "password", email_confirmed_at: 1.minute.ago)
      p1 = Product.create!(provider_identifier: "s123456789", provider: :ikea)
      p2 = Product.create!(provider_identifier: "abcdefghijk", provider: :ikea)

      Tracker.create!(
        title: "Incredible Sofa",
        url: "http://example.com/abcdefghijkl",
        threshold_price: 29_999,
        user: user,
        product: p1,
      )

      Tracker.create!(
        title: "Another thing",
        url: "http://example2.com",
        threshold_price: 10_000,
        user: user,
        product: p2,
      )

      Tracker.create!(
        title: "Another, better, thing",
        url: "http://example3.com",
        threshold_price: 25_000,
        user: user,
        product: p2,
      )

      Price.create!(
        product: p1,
        value: 30_000,
        created_at: 1.day.ago
      ).update(created_at: 1.day.ago)

      Price.create!(
        product: p1,
        value: 25_000,
        created_at: 1.day.ago
      ).update(created_at: 2.days.ago)

      Price.create!(
        product: p1,
        value: 40_000,
      ).update(created_at: 3.days.ago)
    end
  end
end
