# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserFilters::PreferredBrandCars do
  describe '#call' do
    subject(:context) { described_class.call(scope: Car.joins(:brand), user: user, collection_ids: collection_ids) }

    context 'without filters' do
      let(:user) { create(:user, preferred_price_range: 55_000...70_000) }
      let(:filters) { {} }

      let(:brand) { create(:brand, name: "Volkswagen") }
      let(:perfect_match_car) { create(:car, brand_id: brand.id, model: 'Amarok', price: 59_000) }
      let!(:preferred_brand_car) { create(:car, brand_id: brand.id, model: 'Jetta', price: 35_000) }
      let!(:user_preferred_brand) { create(:user_preferred_brand, user_id: user.id, brand_id: brand.id) }
      let(:collection_ids) { [perfect_match_car.id] }

      it "succeeds" do
        expect(context).to be_a_success
      end

      it 'returns the collection ids' do
        expect(context.collection_ids).to eq([perfect_match_car.id, preferred_brand_car.id])
      end
    end
  end
end
