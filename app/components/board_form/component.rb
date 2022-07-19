# frozen_string_literal: true

class BoardForm::Component < ApplicationComponent
  attr_reader :board

  def initialize(board:)
    @board = board
  end
end
