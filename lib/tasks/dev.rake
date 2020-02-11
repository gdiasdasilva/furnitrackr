# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      user = User.create!(
        email: 'goncalo@example.com',
        password: 'password'
      )

      p1 = Product.create!(
        provider_identifier: 's123456789',
        provider: Product::PROVIDERS.fetch(:ikea)
      )

      p2 = Product.create!(
        provider_identifier: 'abcdefghijk',
        provider: Product::PROVIDERS.fetch(:ikea)
      )

      Tracker.create!(
        title: 'Incredible Sofa',
        url: 'http://example.com',
        threshold_price: 29_999,
        user: user,
        product: p1
      )

      Tracker.create!(
        title: 'Another thing',
        url: 'http://example2.com',
        threshold_price: 10_000,
        user: user,
        product: p2
      )
    end
  end
end
