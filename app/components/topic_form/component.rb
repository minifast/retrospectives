# frozen_string_literal: true

class TopicForm::Component < ApplicationComponent
  attr_reader :topic

  def initialize(topic:)
    @topic = topic
  end
end
