# frozen_string_literal: true

require "rails_helper"

RSpec.describe BoardTabs::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(board: board)) }

  let(:board) { create(:board, name: "Cheeseboard") }

  before do
    create(:column, board_id: board.id, name: "Cheeses")
    create(:column, board_id: board.id, name: "Olives")
  end

  it { is_expected.to have_content("Cheeses") }
  it { is_expected.to have_content("Olives") }
end
