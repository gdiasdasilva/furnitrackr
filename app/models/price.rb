class Price < ApplicationRecord
  belongs_to :product

  validates :product_id, presence: true
  validates :value, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
