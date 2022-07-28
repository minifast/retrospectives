require 'rails_helper'

RSpec.describe Column, type: :model do
  subject(:column) { build(:column) }

  it { is_expected.to belong_to(:board).inverse_of(:columns) }
  it { is_expected.to have_many(:topics).inverse_of(:column).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:board_id) }
end
