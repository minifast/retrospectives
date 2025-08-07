require "rails_helper"

RSpec.describe Topic do
  subject(:topic) { build(:topic) }

  it { is_expected.to belong_to(:column).inverse_of(:topics) }
  it { is_expected.to belong_to(:user).inverse_of(:topics) }
  it { is_expected.to have_one(:board).through(:column) }

  it { is_expected.to validate_presence_of(:name) }
end
