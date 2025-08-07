# frozen_string_literal: true

require "rails_helper"

RSpec.describe TopicForm::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(topic: topic)) }

  let(:column) { create(:column) }
  let(:topic) { build(:topic, column: column, name: "") }

  it { is_expected.to have_field("Topic name") }

  context "when there are errors" do
    before { topic.valid? }

    it { is_expected.to have_text("Topic name can't be blank") }
  end
end
