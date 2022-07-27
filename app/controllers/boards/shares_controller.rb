class Boards::SharesController < ApplicationController
  def show
    if ActiveSupport::SecurityUtils.secure_compare(current_board.share_token, params[:share_token])
      current_or_guest_user.board_users.create_or_find_by(board: current_board)
      redirect_to current_board, notice: t('.success')
    else
      redirect_to root_path, alert: t('.failure')
    end
  end

  private

  def current_board
    @current_board ||= Board.find(params[:board_id])
  end
end
