require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  describe 'DELETE #destroy' do
    context 'when a user is logged in' do
      let(:user) { FactoryBot.create(:user) }

      before { sign_in(user, scope: :user) }

      it 'redirects to the root path' do
        delete user_session_path
        expect(response).to redirect_to(root_path)
      end

      it 'sets a flash message' do
        delete user_session_path
        expect(flash[:notice]).to eq('Signed out successfully.')
      end
    end

    context 'when a user is not logged in' do
      it 'redirects to the root path' do
        delete user_session_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
