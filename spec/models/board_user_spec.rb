require "rails_helper"

RSpec.describe BoardUser do
  subject(:board_user) { build(:board_user) }

  it { is_expected.to belong_to(:user).inverse_of(:board_users) }
  it { is_expected.to belong_to(:board).inverse_of(:board_users) }
end
