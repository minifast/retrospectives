# frozen_string_literal: true

require "rails_helper"

RSpec.describe Header::Component, type: :component do
  let(:component) { described_class.new }
  subject(:rendered) { render_inline(component) }

  it { is_expected.to have_content('Retro').and have_text('Boards') }

  context 'when a user is signed in' do
    let(:user) { FactoryBot.create(:user) }

    before { sign_in(user, scope: :user) }

    it { is_expected.to have_content('Sign out') }

    context 'when the current path is not on the boards path' do
      around do |example|
        with_request_url "/boards/1" do
          example.run
        end
      end

      it { is_expected.to have_link('Boards') }
    end
  end
end
