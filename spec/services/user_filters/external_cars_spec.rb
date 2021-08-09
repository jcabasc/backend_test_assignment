# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserFilters::ExternalCars do
  describe '#call' do
    subject(:context) { described_class.call(scope: Car.joins(:brand), user: user, collection_ids: collection_ids) }

    context 'without filters' do
      let(:user) { create(:user, preferred_price_range: 55_000...70_000) }
      let(:filters) { {} }
      let(:brand) { create(:brand, name: "Volkswagen") }
      let(:brand2) { create(:brand, name: "Volvo") }
      let(:perfect_match_car) { create(:car, brand_id: brand.id, model: 'Amarok', price: 59_000) }
      let(:preferred_brand_car) { create(:car, brand_id: brand.id, model: 'Jetta', price: 35_000) }
      let!(:external_car) { create(:car, brand_id: brand2.id, model: 'XC60', price: 99_000) }
      let(:collection_ids) { [perfect_match_car.id, preferred_brand_car.id] }

      before do
        allow(ExternalRecommendationService).to receive(:call).and_return({ external_car.id => 0.871 })
      end

      it "succeeds" do
        expect(context).to be_a_success
      end

      it 'returns the collection ids' do
        expect(context.collection_ids).to eq([perfect_match_car.id, preferred_brand_car.id, external_car.id])
      end
    end
  end
end
