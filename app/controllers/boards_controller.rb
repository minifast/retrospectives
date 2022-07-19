class BoardsController < ApplicationController
  before_action :authenticate_user!

  class BoardForm
    include ActiveModel::Model

    attr_accessor :board, :name, :view_context

    delegate :model_name, :errors, to: :board, allow_nil: true

    def create
      return false unless board.update(name: name)

      board.broadcast_prepend_later_to('boards', html: Board::Component.new(board: board).render_in(view_context))
      true
    end
  end

  def index
    @boards = Board.most_recent
  end

  def show
    @board = Board.find(params[:id])
  end

  def new
    @board = BoardForm.new(board: Board.new)
  end

  def edit
    @board = Board.find(params[:id])
  end

  def create
    @board = BoardForm.new(board_params.to_unsafe_h.merge(board: Board.new, view_context: view_context))

    respond_to do |format|
      if @board.create
        format.turbo_stream { flash.now[:notice] = t('.success') }
        format.html { redirect_to boards_url, notice: t('.success') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to board_url(@board), notice: t('.success') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Board.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to boards_url, notice: t('.success') }
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end
end
