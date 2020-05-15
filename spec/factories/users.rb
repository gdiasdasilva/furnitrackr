FactoryBot.define do
  sequence(:email) { |n| "email-#{n}@example.com" }
  sequence(:email_confirmation_token) { |n| "abcdefghijkl-#{n}" }

  factory :user do
    email
    password { "password" }
    email_confirmed_at { 1.day.ago }

    trait :unconfirmed do
      email_confirmed_at { nil }
    end
  end
end
