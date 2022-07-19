# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Avatar::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(user: user)) }

  let(:user) { create(:user, name: 'Doc') }

  it { is_expected.to have_css('img[alt=Doc]') }
end
