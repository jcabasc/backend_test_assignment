# frozen_string_literal: true

module UserFilters
  class ExternalCars
    include Interactor
    delegate :user, :collection_ids, to: :context

    def call
      external_cars_recommended.delete_if {|car_id, _rank_score| collection_ids.include?(car_id) }

      context.collection_ids += external_cars_recommended.keys.first(5)
    end

    private

    def external_cars_recommended
      @external_cars_recommended ||= ExternalRecommendationService.call(user.id)
    end

  end
end
