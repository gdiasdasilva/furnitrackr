class Price < ApplicationRecord
  belongs_to :product
  validates :product_id, presence: true
  validates :value, presence: true, numericality: { only_integer: true, greater_than: 0 }
  scope :since, ->(datetime) { where("prices.created_at >= ?", datetime) }

  def self.group_by_day
    order(:created_at).limit(10).pluck(:created_at, :value)
      .map { |p| [p.first.to_date, p.last / 100.0] }
  end
end
