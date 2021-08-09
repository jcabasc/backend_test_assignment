# frozen_string_literal: true

module UserFilters
  class PreferredBrandCars
    include Interactor
    delegate :scope, :user, :collection_ids, to: :context

    def call
      ids = scope
              .where
              .not(id: collection_ids)
              .preferred_brands(preferred_brand_names)
              .pluck(:id)

      context.collection_ids += ids
    end

    private

    def preferred_brand_names
      user.preferred_brands.map{ |brand| brand.name.downcase }
    end
  end
end
