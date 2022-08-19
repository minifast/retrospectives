require 'rails_helper'

RSpec.describe Hotwire::Jasmine::SuitesController, type: :request do
  describe 'GET #index' do
    def make_request
      get hotwire_jasmine_suites_path
    end

    context 'when the path has specs in it' do
      before do
        Hotwire::Jasmine.configure do |config|
          config.paths = [Rails.root.join('spec/fixtures/jasmine')]
        end
      end

      it 'runs all specs' do
        make_request
        expect(page).to have_content('spec/fixtures/jasmine/example.spec.js')
      end
    end
  end
end
