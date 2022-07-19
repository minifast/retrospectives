# frozen_string_literal: true

class BoardsList::Component < ApplicationComponent
  attr_reader :boards

  def initialize(boards:)
    @boards = boards
  end
end
