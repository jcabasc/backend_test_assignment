# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserFilters::PerfectMatchCars do
  describe '#call' do
    subject(:context) do
      described_class.call(
        scope: Car.joins(:brand),
        user: user,
        collection_ids: [],
        external_cars_recommended: {}
      )
    end

    context 'without filters' do
      before { create(:user_preferred_brand, user_id: user.id, brand_id: brand.id) }

      let(:user) { create(:user, preferred_price_range: 55_000...70_000) }
      let(:filters) { {} }
      let!(:brand) { create(:brand, name: 'Volkswagen') }
      let!(:perfect_match_car) { create(:car, brand_id: brand.id, model: 'Amarok', price: 59_000) }

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'returns the collection ids' do
        expect(context.collection_ids).to eq([perfect_match_car.id])
      end
    end
  end
end
