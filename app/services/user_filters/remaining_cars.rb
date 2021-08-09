# frozen_string_literal: true

module UserFilters
  class RemainingCars
    include Interactor
    delegate :scope, :collection_ids, to: :context

    def call
      ids = scope.
        where.
        not(id: collection_ids).
        order(:price).
        pluck(:id)

      context.collection_ids += ids
    end
  end
end
