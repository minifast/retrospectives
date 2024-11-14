require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }

  it { is_expected.to have_many(:board_users).inverse_of(:user).dependent(:destroy) }
  it { is_expected.to have_many(:topics).inverse_of(:user).dependent(:destroy) }
  it { is_expected.to have_many(:boards).through(:board_users) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:image_url) }

  describe 'validations' do
    context 'when the email address already exists' do
      let(:user) { build(:user, email: 'awesome@example.com') }

      before { create(:user, email: 'awesome@example.com') }

      it 'is not valid' do
        expect(user).not_to be_valid
      end
    end

    context 'when the email address is unique' do
      let(:user) { build(:user, email: 'awesome@example.com') }

      before { create(:user, email: 'amazing@example.com') }

      it 'is valid' do
        expect(user).to be_valid
      end
    end
  end
end
