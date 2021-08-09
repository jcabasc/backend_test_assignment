# frozen_string_literal: true

module Api
  class CarRecommendationsController < ApplicationController
    def index
      service = CarRecommendationService.new(user_id_param, query_params)

      render json: service.call,
             user: service.user,
             preferred_brand_ids: service.user.preferred_brand_ids,
             external_cars_recommended: service.external_cars_recommended,
             adapter: :json
    end

    private

    def user_id_param
      params.require(:user_id)
    end

    def query_params
      params.permit(:query, :price_min, :price_max)
    end
  end
end
