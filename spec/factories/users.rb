FactoryBot.define do
  sequence(:email) { |n| "email-#{n}@example.com" }

  factory :user do
    email
    password { "password" }
  end
end
