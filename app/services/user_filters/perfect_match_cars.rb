# frozen_string_literal: true

module UserFilters
  class PerfectMatchCars
    include Interactor
    delegate :scope, :user, to: :context

    def call
      ids = scope.
        preferred_brands(preferred_brand_names).
        preferred_prices(user.preferred_price_range).
        pluck(:id)

      context.collection_ids += ids
    end

    private

    def preferred_brand_names
      user.preferred_brands.map { |brand| brand.name.downcase }
    end
  end
end
