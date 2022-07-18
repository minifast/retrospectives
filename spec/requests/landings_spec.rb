require 'rails_helper'

RSpec.describe 'LandingsController', type: :request do
  describe 'GET #show' do
    it 'renders a login button' do
      get root_path
      expect(page).to have_content('Retrospectives').and have_button('Sign in')
    end
  end
end
