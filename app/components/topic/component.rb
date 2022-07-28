# frozen_string_literal: true

class Topic::Component < ApplicationComponent
  with_collection_parameter :topic

  attr_reader :topic

  def initialize(topic:)
    @topic = topic
  end
end
