# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      User.create(
        email: 'goncalo@example.com',
        password: 'password'
      )
    end
  end
end
