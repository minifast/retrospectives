# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardUsers::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(board: board)) }

  let(:board) { create(:board, name: 'Cheeseboard') }

  it { is_expected.not_to have_css('img') }

  context 'when a user is attached to the board' do
    let(:user) { create(:user, name: 'Minifast User') }

    before { create(:board_user, board: board, user: user) }

    it { is_expected.to have_css("img[alt='Minifast User']") }
  end
end
