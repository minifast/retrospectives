require 'rails_helper'

RSpec.describe Board, type: :model do
  subject(:board) { build(:board) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe '.most_recent' do
    context 'when there are no boards' do
      specify { expect(described_class.most_recent).to be_none }
    end

    context 'when there is one board' do
      let!(:board) { create(:board) }

      specify { expect(described_class.most_recent).to eq([board]) }
    end

    context 'when there are two boards' do
      let!(:board) { create(:board) }
      let!(:older_board) { create(:board, created_at: 1.year.ago) }

      specify { expect(described_class.most_recent).to eq([board, older_board]) }
    end
  end
end
