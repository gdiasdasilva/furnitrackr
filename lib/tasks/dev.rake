# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      user = User.create!(
        email: 'goncalo@example.com',
        password: 'password'
      )

      Tracker.create!(
        title: 'Incredible Sofa',
        url: 'http://example.com',
        threshold_price: 299.99,
        user: user
      )

      Tracker.create!(
        title: 'Another thing',
        url: 'http://example2.com',
        threshold_price: 100,
        user: user
      )
    end
  end
end
