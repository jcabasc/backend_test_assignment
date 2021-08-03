# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalRecommendationService do
  describe '#call' do
    let(:user_id) { 1 }
    let(:expected_response) do
      "[\n  { \"car_id\": 179, \"rank_score\": 0.945 }\n]\n"
    end

    context 'success' do
      before do
        allow(Net::HTTP).to receive(:get).and_return(expected_response)
      end

      it 'returns the parsed response' do
        parsed_response = described_class.call(user_id)

        expect(parsed_response).to be_a(Array)
        expect(parsed_response[0]['car_id']).to eq(179)
        expect(parsed_response[0]['rank_score']).to eq(0.945)
      end
    end
  end
end
