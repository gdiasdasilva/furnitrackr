# frozen_string_literal: true

class Tracker < ApplicationRecord
  belongs_to :user
  belongs_to :product

  def display_price_euros
    threshold_price.to_f / 100
  end
end
