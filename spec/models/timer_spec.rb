require 'rails_helper'

RSpec.describe Timer, type: :model do
  subject(:timer) { build(:timer) }

  it { is_expected.to belong_to(:board).inverse_of(:timer) }

  it { is_expected.to validate_uniqueness_of(:board_id) }
  it { is_expected.to validate_presence_of(:duration) }
  it { is_expected.to validate_numericality_of(:duration).is_greater_than(0) }
end
