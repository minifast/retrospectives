class BoardsController < ApplicationController
  before_action :authenticate_user!

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

    attr_accessor :id, :name
    attr_writer :columns

    validates :name, presence: true
    validates_with ColumnsValidator

    def persisted?
      id.present?
    end

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

    def create(board, view_context)
      return false unless [valid?, columns_create_valid?].all?

      board.update(name: name, columns_attributes: columns.map(&:to_h))
      board.broadcast_prepend_later_to(
        'boards',
        html: Board::Component.new(board: board).render_in(view_context)
      )
      true
    end

    def update(board, view_context)
      return false unless [valid?, columns_update_valid?].all?

      board.update(name: name, columns_attributes: @columns.map(&:to_h).map(&:compact))
      board.broadcast_replace_later_to(
        'boards',
        target: view_context.dom_id(board),
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
    set_page_and_extract_portion_from Board.all, ordered_by: {created_at: :desc, id: :desc}
  end

  def show
    @board = current_board
  end

  def new
    @board = BoardForm.new(columns: [ColumnForm.new])
  end

  def edit
    columns = current_board.columns.map { |c| ColumnForm.new(id: c.id, name: c.name) }
    @board = BoardForm.new(id: current_board.id, name: current_board.name, columns: columns)
  end

  def create
    @board = BoardForm.new(board_params)

    respond_to do |format|
      if @board.create(Board.new, view_context)
        format.turbo_stream { flash.now[:notice] = t('.success') }
        format.html { redirect_to boards_url, notice: t('.success') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @board = BoardForm.new(board_params.merge(id: current_board.id))

    respond_to do |format|
      if @board.update(current_board, view_context)
        format.turbo_stream { flash.now[:notice] = t('.success') }
        format.html { redirect_to board_url(current_board), notice: t('.success') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url, notice: t('.success') }
    end
  end

  private

  def current_board
    @current_board ||= Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name, columns_attributes: [:id, :name, :board_order_position, :_destroy])
  end
end
