# frozen_string_literal: true

class Tracker < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :prices, through: :product

  validates :product_id, presence: true
  validates :url, presence: true
  validates :threshold_price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :user, presence: true

  scope :enabled, -> { where(enabled: true) }

  before_save :cleanup_url

  def display_price_euros
    "#{Money.new(threshold_price)}€"
  end

  def fetch_current_price
    return prices.order(:created_at).last if prices.since(Date.today.beginning_of_day).any?

    begin
      current_price_euros = FetchPriceFromProviderService.new(url: url).call
    rescue RuntimeError => e
      errors.add(:base, "Could not fetch price from product URL.")
      Bugsnag.notify(e)
      return
    end

    if current_price_euros.present? && current_price_euros.positive?
      price = Price.create!(
        product: product,
        value: (current_price_euros * 100).to_i,
      )
    else
      errors.add(:base, "Could not fetch price from product URL.")
    end

    price
  end

  def last_fetched_price
    prices.order(created_at: :desc).first
  end

  def price_changed?
    last_price, penultimate_price = prices.order(created_at: :desc).first(2)
    return true if last_price.blank? || penultimate_price.blank?

    last_price.value != penultimate_price.value
  end

  def self.to_notify
    trackers = Tracker.enabled.joins(:prices).distinct(:id)
    trackers.select do |t|
      t.last_fetched_price.value <= t.threshold_price && t.price_changed?
    end
  end

  private

  def cleanup_url
    uri = URI(url)
    self.url = "#{uri.scheme}://#{uri.host}#{uri.path}"
  end
end
