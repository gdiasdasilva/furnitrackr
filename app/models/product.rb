# frozen_string_literal: true

class Product < ApplicationRecord
  PROVIDERS = {
    ikea: 'ikea'
  }.freeze

  has_many :trackers
end
