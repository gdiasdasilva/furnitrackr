FactoryBot.define do
  sequence(:title) { |n| "Example Tracker #{n}" }
  sequence(:url) { |n| "http://example.com/products/tracker-#{n}" }

  factory :tracker do
    title
    url
    threshold_price { 49999 }
    user
    product
  end
end
