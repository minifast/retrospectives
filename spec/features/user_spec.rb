require 'rails_helper'

RSpec.describe 'User signing in' do
  before { FactoryBot.create(:user, email: 'awesome@example.com', password: 'password') }

  it 'signs in a user' do
    visit '/'

    fill_in 'Email', with: 'awesome@example.com'
    fill_in 'Password', with: 'password'

    click_on 'Log in'

    expect(page).to have_text(/welcome to retrospectives/i)
  end
end
