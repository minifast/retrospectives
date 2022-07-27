require 'rails_helper'

RSpec.describe 'Creating a retrospective', js: true do
  before do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(uid: '123545', info: {email: 'user@ministryofvelocity.com', name: 'Minifast User', image: 'https://placekitten.com/80/80'})
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    page.driver.browser.execute_cdp(
      'Browser.setPermission',
      origin: page.server_url,
      permission: {name: 'clipboard-read'},
      setting: 'granted'
    )
    page.driver.browser.execute_cdp(
      'Browser.setPermission',
      origin: page.server_url,
      permission: {name: 'clipboard-write'},
      setting: 'granted'
    )
  end

  it 'adds a board' do
    visit root_path

    click_on 'Sign in'

    create_list(:board, 16, users: User.all)

    visit root_path

    expect(page.all('li').size).to eq(15)

    click_on 'New Board'

    fill_in 'Board name', with: "Today's Retro"

    click_on 'Add Column'

    within('#slideover li:first-of-type') do
      fill_in 'Column name', with: 'Happy'
    end

    within('#slideover li:last-of-type') do
      fill_in 'Column name', with: 'Sad'
    end

    click_on 'Create Board'

    expect(page).to have_content("Today's Retro").and have_text(I18n.l(Time.now.getlocal.to_date, format: :long))
    expect(page.all('li').size).to eq(16)

    scroll_to page.find('a', text: 'Next')

    expect(page).to have_no_link('Next')

    expect(page.all('li').size).to eq(17)

    click_on "Today's Retro"

    expect(page).to have_content("Today's Retro")

    click_on 'Copy Invite Link'

    invite_url = page.evaluate_async_script('navigator.clipboard.readText().then(arguments[0])')
    expect(invite_url).to end_with(board_share_path(Board.most_recent.first, Board.most_recent.first.share_token))

    using_session(:guest) do
      visit invite_url

      expect(page).to have_content("Today's Retro")
      expect(page).to have_css("img[alt='Minifast User']")
      expect(page).to have_css("img[alt='Testing Guest']")
    end

    expect(page).to have_css("img[alt='Minifast User']")
    expect(page).to have_css("img[alt='Testing Guest']")

    click_on 'Edit Board'

    fill_in 'Board name', with: 'Retro of the Day'

    within('#slideover li:first-of-type') do
      fill_in 'Column name', with: 'I want'
    end

    within('#slideover li:last-of-type') do
      fill_in 'Column name', with: 'I need'
    end

    click_on 'Add Column'

    within('#slideover li:last-of-type') do
      fill_in 'Column name', with: 'I love'
    end

    click_on 'Update Board'

    expect(page).to have_content('Retro of the Day')

    click_on 'Start Timer'

    click_on '5 minutes'

    expect(page).to have_content(/\d:\d\d/)

    using_session(:guest) do
      expect(page).to have_content('Retro of the Day')
      expect(page).to have_content(/\d:\d\d/)
    end

    page.find('button', text: /\d:\d\d/).click

    click_on 'Stop Timer'

    expect(page).to have_content('Start Timer')

    using_session(:guest) do |session, previous_session|
      expect(page).to have_content('Start Timer')
      session.quit
      previous_session.quit
    end
  end
end
