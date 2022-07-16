class ColumnsController < ApplicationController
  before_action :setup_board

  def new
  end

  def destroy
  end

  private

  def setup_board
    @board = Board.new(columns: [Column.new])
  end
end
