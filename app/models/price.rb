class Price < ApplicationRecord
  belongs_to :product
  validates :product_id, presence: true
  validates :value, presence: true, numericality: { only_integer: true, greater_than: 0 }
  scope :since, ->(datetime) { where("prices.created_at >= ?", datetime) }

  def self.group_by_day
    order("date_trunc('day', prices.created_at)").pluck("date_trunc('day', prices.created_at)", :value)
  end
end
