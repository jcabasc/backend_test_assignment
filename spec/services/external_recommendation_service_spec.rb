# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalRecommendationService do
  describe '#call' do
    let(:user_id) { 1 }
    let(:expected_response) do
      "[\n  { \"car_id\": 179, \"rank_score\": 0.945 },\n  { \"car_id\": 5, \"rank_score\": 0.4552 },\n  { \"car_id\": 13, \"rank_score\": 0.99 }\n]\n"
    end

    context 'success' do
      before do
        allow(Net::HTTP).to receive(:get).and_return(expected_response)
      end

      it 'returns a hash with car ids as keys' do
        result = described_class.call(user_id)

        expect(result).to be_a(Hash)
        expect(result.keys).to eq([13, 179, 5])
      end

      it 'returns a hash sorted by rank score values asc' do
        result = described_class.call(user_id)

        expect(result.values).to eq([0.99, 0.945, 0.4552])
      end
    end
  end
end
