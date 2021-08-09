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
    context = UserFiltersService.call(scope: scope, user: user, collection_ids: [])
    ParamsFilterQuery.call(context.scope, filters)
  end

  private

  attr :user, :filters, :scope
end
