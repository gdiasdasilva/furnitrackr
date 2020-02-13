# frozen_string_literal: true

class Product < ApplicationRecord
  PROVIDERS = {
    ikea: 'ikea',
  }.freeze

  validates :provider_identifier, presence: true
  validates :provider, presence: true

  has_many :trackers, dependent: :restrict_with_exception
  has_many :prices, dependent: :restrict_with_exception
end
