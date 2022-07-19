class BoardsController < ApplicationController
  before_action :authenticate_user!

  class BoardForm
    include ActiveModel::Model

    attr_accessor :board, :view_context

    delegate :model_name, :errors, to: :board, allow_nil: true

    def create(params)
      return false unless board.update(params)

      board.broadcast_prepend_later_to(
        'boards',
        html: Board::Component.new(board: board).render_in(view_context)
      )
      true
    end

    def update(params)
      return false unless board.update(params)

      board.broadcast_replace_later_to(
        board,
        html: Board::Component.new(board: board).render_in(view_context)
      )
      board.broadcast_replace_later_to(
        board,
        target: view_context.dom_id(board, :header),
        html: BoardHeader::Component.new(board: board).render_in(view_context)
      )
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
    @board = BoardForm.new(board: Board.find(params[:id]))
  end

  def create
    @board = BoardForm.new(board: Board.new, view_context: view_context)

    respond_to do |format|
      if @board.create(board_params)
        format.turbo_stream { flash.now[:notice] = t('.success') }
        format.html { redirect_to boards_url, notice: t('.success') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    instance = Board.find(params[:id])
    @board = BoardForm.new(board: instance, view_context: view_context)

    respond_to do |format|
      if @board.update(board_params)
        format.turbo_stream { flash.now[:notice] = t('.success') }
        format.html { redirect_to board_url(instance), notice: t('.success') }
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
