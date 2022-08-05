# frozen_string_literal: true

class BoardTabs::Component < ApplicationComponent
  attr_reader :board

  def initialize(board:)
    @board = board
  end
end
