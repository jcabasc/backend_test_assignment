# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParamsFilterQuery do
  describe '#call' do
    subject { described_class.call(Car.joins(:brand), filters) }

    before do
      brand = create(:brand, name: "Volkswagen")
      brand2 = create(:brand, name: "Volvo")
      create(:car, brand_id: brand.id, model: 'Amarok', price: 59_000)
      create(:car, brand_id: brand.id, model: 'Jetta', price: 35_000)
      create(:car, brand_id: brand2.id, model: 'XC60', price: 99_000)
      create(:car, brand_id: brand2.id, model: 'XC90', price: 120_000)

    end

    context 'with query filter' do
      let(:filters) { { query: 'Volk' } }

      it 'returns filtered cars' do
        expect(subject.pluck(:model)).to eq(['Amarok', 'Jetta'])
      end
    end

    context 'with price filters' do
      context 'when price_min' do
        let(:filters) { { price_min: '100_000' } }

        it 'returns filtered cars' do
          expect(subject.pluck(:model)).to eq(['XC90'])
        end
      end

      context 'when price_max' do
        let(:filters) { { price_max: '40_000' } }

        it 'returns filtered cars' do
          expect(subject.pluck(:model)).to eq(['Jetta'])
        end
      end

      context 'when both filters' do
        let(:filters) { { price_min: '59_000', price_max: '100_000' } }

        it 'returns filtered cars' do
          expect(subject.pluck(:model)).to eq(['Amarok', 'XC60'])
        end
      end
    end

    context 'with both filters' do
      let(:filters) { { query: 'Volk', price_max: '36_000' } }

      it 'returns filtered cars' do
        expect(subject.pluck(:model)).to eq(['Jetta'])
      end
    end
  end
end
