# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Car, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:brand) }
  end

  describe 'scopes' do
    let(:brand) { create(:brand, name: 'Volkswagen') }
    let(:car) { create(:car, brand_id: brand.id, model: 'Amarok', price: 35_000) }

    describe '#preferred_brands' do
      context 'when there is an exact match' do
        it 'returns the car within the collection' do
          preferred_brand_names = %w[volkswagen Kia]

          scope = described_class.joins(:brand).preferred_brands(preferred_brand_names)
          expect(scope).to include(car)
        end
      end

      context 'when there is a partial match' do
        it 'returns the car within the collection' do
          preferred_brand_names = %w[volks Kia]

          scope = described_class.joins(:brand).preferred_brands(preferred_brand_names)
          expect(scope).to include(car)
        end
      end

      context 'when there is no match' do
        it 'returns an empty collection' do
          preferred_brand_names = %w[Kia]

          scope = described_class.joins(:brand).preferred_brands(preferred_brand_names)
          expect(scope).to eq([])
        end
      end
    end

    describe '#preferred_prices' do
      context 'when there is a match' do
        it 'returns the car within the collection' do
          preferred_price = 20_000...36_000

          scope = described_class.joins(:brand).preferred_prices(preferred_price)
          expect(scope).to include(car)
        end
      end

      context 'when there is no match' do
        it 'returns an empty collection' do
          preferred_price = 20_000...30_000

          scope = described_class.joins(:brand).preferred_prices(preferred_price)
          expect(scope).to eq([])
        end
      end
    end
  end
end
