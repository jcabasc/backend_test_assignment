# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CarRecommendations', type: :request do
  describe '#index' do
    before do
      create(:user_preferred_brand, user_id: user.id, brand_id: brand.id)

      allow(ExternalRecommendationService).to receive(:call).and_return({ car.id.to_s => 0.871 })
    end
    let(:user) { create(:user) }
    let(:brand) { create(:brand, name: 'Volkswagen') }
    let(:car) { create(:car, brand_id: brand.id, model: 'Amarok', price: 59_000) }

    let(:expected_response) do
      {
        'cars'=>[
          {
            'id'=>car.id,
            'price'=>car.price,
            'rank_score'=>nil,
            'model'=>car.model,
            'label'=>'good_match',
            'brand'=>{
              'id'=> brand.id,
              'name'=>brand.name
            }
          }
        ]
      }
    end

    context 'when success' do
      it 'returns a succesfull response' do
        get '/api/car_recommendations', params: { page: 1, user_id: user.id }

        expect(response).to have_http_status(:success)
        expect(response).to be_successful
      end

      it 'returns the correct format' do
        get '/api/car_recommendations', params: { page: 1, user_id: user.id }

        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end
end
