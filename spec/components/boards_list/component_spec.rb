# frozen_string_literal: true

require "rails_helper"

RSpec.describe BoardsList::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(boards: boards)) }

  let(:boards) { GearedPagination::Recordset.new(Board.all, ordered_by: {created_at: :desc, id: :desc}).page(nil) }

  context "when there is a board" do
    before { create(:board, name: "Longboard") }

    it { is_expected.to have_content("Longboard").and have_text(I18n.l(Time.current.utc, format: :long)) }
  end
end
