# frozen_string_literal: true

class CarRecommendationService

  def self.call(user_id, filters)
    new(user_id, filters).call
  end

  def initialize(user_id, filters)
    @user = User.find(user_id)
    @filters = filters
    @scope = Car.joins(:brand)
  end

  def call
    @scope = scope
      .where(id: collection_ids)
      .order_as_specified(id: collection_ids)
      .limit(20)

    filter_car_brands
    filter_car_prices
    scope
  end

  private

  def collection_ids
    @collection_ids ||= perfect_matches | preferred_brands | external_cars | all_cars
  end

  def perfect_matches
   @perfect_matches ||= scope
                          .preferred_brands(preferred_brand_names)
                          .preferred_prices(user.preferred_price_range)
                          .pluck(:id)
  end

  def preferred_brands
    @preferred_brands ||= scope
                            .where
                            .not(id: perfect_matches)
                            .preferred_brands(preferred_brand_names)
                            .pluck(:id)
  end

  def all_cars
    already_matched_cars = perfect_matches | preferred_brands | external_cars
    scope
      .where
      .not(id: already_matched_cars)
      .order(:price)
      .pluck(:id)
  end

  def filter_car_brands
    @scope = scope.where("LOWER(brands.name) ILIKE :query", query: "%#{filters[:query].downcase }%") if filters[:query].present?
  end

  def filter_car_prices
    @scope = scope.where(price: filters[:price_min]...filters[:price_max]) if [filters[:price_min], filters[:price_max]].any?
  end

  def external_cars
    already_matched_cars = perfect_matches | preferred_brands
    external_cars_recommended.delete_if {|car_id, _rank_score| already_matched_cars.include?(car_id) }

    external_cars_recommended.keys.first(5)
  end

  def external_cars_recommended
    @external_cars_recommended ||= ExternalRecommendationService.call(user.id)
  end

  def preferred_brand_names
    user.preferred_brands.map{ |brand| brand.name.downcase }
  end

  attr :user, :filters, :scope
end
