# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:cars).dependent(:destroy) }
  end
end
