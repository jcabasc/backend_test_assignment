# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarRecommendationService do
  describe '.call' do
    subject { described_class.new(user.id, filters).call }

    context 'without filters' do
      let(:user) { create(:user, preferred_price_range: 18_000...45_000) }
      let(:filters) { {} }
      before do
        setup_data_for(user)
      end

      it do
        car_models = %w[Derby e-Golf Brera Arna Amarok EDGE Cross RAVE Explorer Fortuner]
        expect(subject.pluck(:model)).to eq(car_models)
      end
    end

    context 'with filters' do
      let(:user) { create(:user, preferred_price_range: 18_000...89_000) }
      let(:filters) { { price_min: 85_000, query: 'Chevrolet'} }
      before do
        setup_data_for(user)
        brand = create(:brand, name: 'Chevrolet')
        create(:car, brand_id: brand.id, model: 'Equinox', price: 89_000)
      end

      it do
        car_models = %w[Equinox]
        expect(subject.pluck(:model)).to eq(car_models)
      end
    end
  end
end

def setup_data_for(user)
  ['Alfa Romeo', 'Volkswagen', 'Toyota', 'Ford'].each do |brand_name|
    brand = create(:brand, name: brand_name)
    if ['Alfa Romeo', 'Volkswagen'].include?(brand_name)
      user.preferred_brands << brand
    end

    case brand_name
    when 'Volkswagen'
      create(:car, brand_id: brand.id, model: 'Derby', price: 18_000)
      create(:car, brand_id: brand.id, model: 'e-Golf', price: 35_000)
      create(:car, brand_id: brand.id, model: 'Amarok', price: 59_000)
    when 'Alfa Romeo'
      create(:car, brand_id: brand.id, model: 'Brera', price: 45_000)
      create(:car, brand_id: brand.id, model: 'Arna', price: 88_000)
    when 'Toyota'
      create(:car, brand_id: brand.id, model: 'Cross', price: 47_00)
      create(:car, brand_id: brand.id, model: 'RAVE', price: 66_999)
      create(:car, brand_id: brand.id, model: 'Fortuner', price: 96_000)
    else
      car = create(:car, brand_id: brand.id, model: 'EDGE', price: 77_000)
      create(:car, brand_id: brand.id, model: 'Explorer', price: 89_000)

      allow(ExternalRecommendationService).to receive(:call).and_return({ car.id.to_s => 0.871 })
    end
  end
end
