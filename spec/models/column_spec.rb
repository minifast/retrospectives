require 'rails_helper'

RSpec.describe Column, type: :model do
  it { is_expected.to belong_to(:board).inverse_of(:columns) }
end
