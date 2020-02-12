# frozen_string_literal: true

class Tracker < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :product_id, presence: true
  validates :url, presence: true
  validates :threshold_price, presence: true
  validates :user, presence: true

  def display_price_euros
    threshold_price.to_f / 100
  end
end
