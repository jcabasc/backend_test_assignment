# frozen_string_literal: true

class UserFiltersService
  include Interactor::Organizer

  organize(
    UserFilters::PerfectMatchCars,
    UserFilters::PreferredBrandCars,
    UserFilters::ExternalCars,
    UserFilters::RemainingCars,
    UserFilters::FinalCars
  )
end
