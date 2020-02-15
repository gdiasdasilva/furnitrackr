FactoryBot.define do
  sequence(:provider_identifier) { |n| "example-identifier-#{n}" }

  factory :product do
    provider_identifier
    provider { :ikea }
  end
end
