require 'rails_helper'

RSpec.describe 'Creating a retrospective', js: true do
  before do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(uid: '123545', info: {email: 'user@ministryofvelocity.com', name: 'User', image: 'https://placekitten.com/80/80'})
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  it 'adds a board' do
    visit root_path

    click_on 'Sign in'

    click_on 'New Board'

    fill_in 'Name', with: "Today's Retro"

    click_on 'Create Board'

    expect(page).to have_content("Today's Retro").and have_text(I18n.l(Time.current.utc.to_date, format: :long))

    click_on "Today's Retro"

    expect(page).to have_content("Today's Retro")

    click_on 'Edit Board'

    fill_in 'Name', with: 'Retro of the Day'

    click_on 'Update Board'

    expect(page).to have_content('Retro of the Day')
  end
end
