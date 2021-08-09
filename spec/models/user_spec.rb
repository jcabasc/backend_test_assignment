# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:user_preferred_brands).dependent(:destroy) }
    it { is_expected.to have_many(:preferred_brands).through(:user_preferred_brands) }
  end
end
