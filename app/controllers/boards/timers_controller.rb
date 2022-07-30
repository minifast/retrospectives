class Boards::TimersController < ApplicationController
  class TimerForm
    include ActiveModel::Model

    attr_accessor :board
    attr_reader :duration

    delegate :timer, to: :board, allow_nil: true
    delegate :ends_at, to: :timer, allow_nil: true

    validates :duration, numericality: {greater_than: 0}, on: :create
    validates :persisted?, inclusion: {in: [true]}, on: :destroy

    def duration=(value)
      @duration = value.to_i
    end

    def persisted?
      board.timer&.persisted?
    end

    def create(view_context)
      return false unless valid?(:create)

      board.timer = Timer.new(duration: duration)
      board.broadcast_replace_later_to(
        board,
        target: view_context.dom_id(board, :timer),
        html: Timer::Component.new(timer: board.timer).render_in(view_context)
      )
      true
    end

    def destroy(view_context)
      return false unless valid?(:destroy)

      board.timer.destroy
      board.broadcast_replace_later_to(
        board,
        target: view_context.dom_id(board, :timer),
        html: Timer::Component.new(timer: board.timer).render_in(view_context)
      )
      true
    end
  end

  def show
    authorize(current_board, :show?)
    @timer = TimerForm.new(board: current_board, duration: current_board.timer&.duration)
  end

  def create
    authorize(current_board, :update?)
    @timer = TimerForm.new(timer_params.merge(board: current_board))

    respond_to do |format|
      if @timer.create(view_context)
        format.turbo_stream { flash.now[:notice] = t('.success') }
        format.html { redirect_to board_timer_url(current_board), notice: t('.success') }
      else
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  rescue Pundit::NotAuthorizedError
    respond_to do |format|
      format.turbo_stream { flash.now[:alert] = t('.alert') }
      format.html { redirect_to board_timer_url(current_board), alert: t('.alert') }
    end
  end

  def destroy
    authorize(current_board, :update?)
    @timer = TimerForm.new(board: current_board)

    respond_to do |format|
      if @timer.destroy(view_context)
        format.turbo_stream { flash.now[:notice] = t('.success') }
        format.html { redirect_to board_timer_url(current_board), notice: t('.success') }
      else
        format.html { redirect_to board_timer_url(current_board) }
      end
    end
  rescue Pundit::NotAuthorizedError
    respond_to do |format|
      format.turbo_stream { flash.now[:alert] = t('.alert') }
      format.html { redirect_to board_timer_url(current_board), alert: t('.alert') }
    end
  end

  private

  def current_board
    @current_board ||= Board.find(params[:board_id])
  end

  def timer_params
    params.require(:timer).permit(:duration)
  end
end
