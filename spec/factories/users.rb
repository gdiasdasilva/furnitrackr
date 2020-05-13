FactoryBot.define do
  sequence(:email) { |n| "email-#{n}@example.com" }

  factory :user do
    email
    password { "password" }
    email_confirmed_at { 1.day.ago }
  end
end
