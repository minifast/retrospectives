require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
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
  end
end
