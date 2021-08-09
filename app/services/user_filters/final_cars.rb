# frozen_string_literal: true

module UserFilters
  class FinalCars
    include Interactor
    delegate :scope, :collection_ids, to: :context

    def call
      filtered_scope = scope
                        .where(id: collection_ids)
                        .order_as_specified(id: collection_ids)
      context.scope = filtered_scope
    end
  end
end
