class BoardsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  class ColumnForm
    include ActiveModel::Model

    attr_accessor :id, :name
    attr_reader :_destroy

    validates :name, presence: true, unless: :_destroy
    validates :_destroy, exclusion: {in: [true]}, on: :create
    validates :id, absence: true, on: :create

    def self.model_name
      Column.model_name
    end

    def _destroy=(value)
      @_destroy = ActiveModel::Type::Boolean.new.cast(value)
    end

    def persisted?
      id.present?
    end

    def to_h
      {id: id, name: name, _destroy: _destroy}
    end
  end

  class BoardForm
    include ActiveModel::Model

    class ColumnsValidator < ActiveModel::Validator
      def validate(model)
        model.errors.add(:columns, :blank) if model.columns.reject(&:_destroy).empty?
      end
    end

    attr_accessor :board, :name
    attr_writer :columns

    delegate :persisted?, :share_token, :id, :users, to: :board, allow_nil: true

    validates :name, presence: true
    validates_with ColumnsValidator

    def self.model_name
      Board.model_name
    end

    def columns
      @columns || []
    end

    def columns_attributes=(attributes)
      @columns = attributes.map { |_, params| ColumnForm.new(params) }
    end

    def columns_create_valid?
      @columns&.map { |c| c.valid?(:create) }&.all?
    end

    def columns_update_valid?
      @columns&.map { |c| c.valid?(:update) }&.all?
    end

    def create(view_context)
      return false unless [valid?, columns_create_valid?].all?

      board.update(name: name, columns_attributes: columns.map(&:to_h))
      board.users.each do |user|
        board.broadcast_prepend_later_to(
          user,
          target: view_context.dom_id(user, :boards),
          html: Board::Component.new(board: board).render_in(view_context)
        )
      end
      true
    end

    def update(view_context)
      return false unless [valid?, columns_update_valid?].all?

      old_columns = board.columns.to_a
      board.update(name: name, columns_attributes: columns.map(&:to_h).map(&:compact))
      removed_columns = old_columns - board.reload.columns.to_a
      new_columns = board.columns.to_a - old_columns
      remaining_columns = board.columns.to_a - new_columns

      board.users.each do |user|
        board.broadcast_replace_later_to(
          user,
          target: view_context.dom_id(user, :boards),
          html: Board::Component.new(board: board).render_in(view_context)
        )
      end
      board.broadcast_replace_later_to(
        board,
        target: view_context.dom_id(board, :header),
        html: BoardHeader::Component.new(board: board).render_in(view_context)
      )
      board.broadcast_replace_later_to(
        board,
        target: view_context.dom_id(board, :tabs),
        html: BoardTabs::Component.new(board: board).render_in(view_context)
      )
      removed_columns.each do |column|
        board.broadcast_remove_to(board, target: view_context.dom_id(column))
      end
      remaining_columns.each do |column|
        board.broadcast_replace_later_to(
          board,
          target: view_context.dom_id(column),
          html: BoardColumn::Component.new(column: column).render_in(view_context)
        )
      end
      new_columns.each do |column|
        board.broadcast_append_later_to(
          board,
          target: view_context.dom_id(board, :columns),
          html: BoardColumn::Component.new(column: column).render_in(view_context)
        )
      end
      true
    end
  end

  def index
    authorize(Board)
    set_page_and_extract_portion_from policy_scope(Board), ordered_by: {created_at: :desc, id: :desc}
  end

  def show
    authorize(current_board)
    @board = current_board
  end

  def new
    authorize(Board)
    @board = BoardForm.new(board: Board.new(users: [current_user]), columns: [
      ColumnForm.new(name: "Happy"),
      ColumnForm.new(name: "Meh"),
      ColumnForm.new(name: "Sad")
    ])
  end

  def edit
    authorize(current_board)
    columns = current_board.columns.map { |c| ColumnForm.new(id: c.id, name: c.name) }
    @board = BoardForm.new(board: current_board, name: current_board.name, columns: columns)
  end

  def create
    authorize(Board)
    @board = BoardForm.new(board_params.merge(board: Board.new(users: [current_user])))
    respond_to do |format|
      if @board.create(view_context)
        format.turbo_stream { redirect_to boards_url, status: :see_other, notice: t(".success") }
        format.html { redirect_to boards_url, notice: t(".success") }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize(current_board)
    @board = BoardForm.new(board_params.merge(board: current_board))

    respond_to do |format|
      if @board.update(view_context)
        format.turbo_stream { redirect_to board_url(current_board), status: :see_other, notice: t(".success") }
        format.html { redirect_to board_url(current_board), notice: t(".success") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize(current_board)
    current_board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url, notice: t(".success") }
    end
  end

  private

  def current_board
    @current_board ||= Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name, columns_attributes: [:id, :name, :_destroy])
  end
end
