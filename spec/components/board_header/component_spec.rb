# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardHeader::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(board: board)) }

  let(:board) { create(:board, name: 'Cheeseboard') }

  it { is_expected.to have_content('Cheeseboard') }
end
