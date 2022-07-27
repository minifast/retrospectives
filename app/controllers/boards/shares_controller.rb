class Boards::SharesController < ApplicationController
  class ShareForm
    class TokenValidator < ActiveModel::Validator
      def validate(model)
        unless ActiveSupport::SecurityUtils.secure_compare(model.board.share_token, model.share_token)
          model.errors.add(:share_token, :invalid)
        end
      end
    end

    include ActiveModel::Model

    attr_accessor :board, :user, :share_token

    validates_with TokenValidator

    def save(view_context)
      return false unless valid?

      user.board_users.create_or_find_by(board: board)
      board.broadcast_replace_later_to(
        board,
        target: view_context.dom_id(board, :users),
        html: BoardUsers::Component.new(board: board).render_in(view_context)
      )
      true
    end
  end

  def show
    form = ShareForm.new(board: current_board, user: current_or_guest_user, share_token: params[:share_token])
    if form.save(view_context)
      redirect_to current_board, notice: t('.success')
    else
      redirect_to root_path, alert: form.errors.full_messages.first
    end
  end

  private

  def current_board
    @current_board ||= Board.find(params[:board_id])
  end
end
