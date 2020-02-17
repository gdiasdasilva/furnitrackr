# frozen_string_literal: true

class Tracker < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :prices, through: :product

  validates :product_id, presence: true
  validates :url, presence: true
  validates :threshold_price, presence: true
  validates :user, presence: true

  def display_price_euros
    "#{Money.new(threshold_price)} €"
  end

  def fetch_current_price
    current_price_euros = FetchPriceFromProviderService.new(url: url).call

    if current_price_euros.present? && current_price_euros.positive?
      Price.create!(
        product: product,
        value: (current_price_euros * 100).to_i,
      )
    end
  end
end
