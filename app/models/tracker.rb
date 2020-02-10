class Tracker < ApplicationRecord
  belongs_to :user

  def display_price_euros
    threshold_price.to_f / 100
  end
end
