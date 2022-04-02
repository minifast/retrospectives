require 'rails_helper'
RSpec.describe 'Sign in' do
  context 'when user is not signed in' do
    before do
      visit '/'
    end

    it 'display a title' do
      expect(page).to have_text('sign in')
    end
  end
end
