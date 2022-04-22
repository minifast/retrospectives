require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    context 'when the email address already exists' do
      let(:user) { FactoryBot.build(:user, email: 'awesome@example.com') }

      before { FactoryBot.create(:user, email: 'awesome@example.com') }

      it 'is not valid' do
        expect(user).not_to be_valid
      end
    end

    context 'when the email address is unique' do
      let(:user) { FactoryBot.build(:user, email: 'awesome@example.com') }

      before { FactoryBot.create(:user, email: 'amazing@example.com') }

      it 'is valid' do
        expect(user).to be_valid
      end
    end

    context 'when the password has less than 6 characters' do
      let(:user) { FactoryBot.build(:user, password: 'Hi') }

      it 'is not valid' do
        expect(user).not_to be_valid
      end
    end

    context 'when the password has more than 6 characters' do
      let(:user) { FactoryBot.build(:user, password: 'password') }

      it 'is valid' do
        expect(user).to be_valid
      end
    end
  end
end
