# frozen_string_literal: true

class Board::Component < ApplicationComponent
  with_collection_parameter :board

  attr_reader :board

  def initialize(board:)
    @board = board
  end
end
