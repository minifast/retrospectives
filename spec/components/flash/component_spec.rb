# frozen_string_literal: true

require "rails_helper"

RSpec.describe Flash::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(flash: flash_hash)) }

  let(:flash_hash) { {} }

  it "renders an empty fragment" do
    expect(rendered.text).to eq("")
  end

  context "when there is an alert" do
    let(:flash_hash) { {alert: "There goes your data!"} }

    it { is_expected.to have_content("data") }
  end

  context "when there is a notice" do
    let(:flash_hash) { {notice: "Here comes some data!"} }

    it { is_expected.to have_content("data") }
  end

  context "when there is a custom notification" do
    let(:flash_hash) { {ducks: "Are ducks the best?"} }

    it { is_expected.to have_content("ducks") }
  end
end
