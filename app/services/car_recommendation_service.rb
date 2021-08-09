# frozen_string_literal: true

class CarRecommendationService
  attr :user, :filters, :scope, :external_cars_recommended

  def initialize(user_id, filters)
    @user = User.find(user_id)
    @filters = filters
    @scope = Car.joins(:brand)
    @external_cars_recommended = ExternalRecommendationService.call(user.id)
  end

  def call
    context = UserFiltersService.call(scope: scope, user: user, collection_ids: [], external_cars_recommended: external_cars_recommended)
    ParamsFilterQuery.call(context.scope, filters)
  end
end
