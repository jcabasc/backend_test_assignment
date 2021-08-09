# frozen_string_literal: true

class ParamsFilterQuery

  def self.call(scope, filters)
    new(scope, filters).call
  end

  def initialize(scope, filters)
    @scope = scope
    @filters = filters
  end

  def call
    filter_car_brands
    filter_car_prices
    scope
  end

  private

  attr :scope, :filters

  def filter_car_brands
    @scope = scope.where("LOWER(brands.name) ILIKE :query", query: "%#{filters[:query].downcase }%") if filters[:query].present?
  end

  def filter_car_prices
    @scope = scope.where(price: filters[:price_min]...filters[:price_max]) if [filters[:price_min], filters[:price_max]].any?
  end
end
