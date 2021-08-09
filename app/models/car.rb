# frozen_string_literal: true

class Car < ApplicationRecord
  extend OrderAsSpecified
  belongs_to :brand

  scope :preferred_brands, ->(preferred_brand_names) do
    where("LOWER(brands.name) ~ '^(#{preferred_brand_names.join('|')}).*'")
  end

  scope :preferred_prices, ->(preferred_price_range) do
    where(price: preferred_price_range)
  end
end
