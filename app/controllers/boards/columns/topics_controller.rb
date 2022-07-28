class Boards::Columns::TopicsController < ApplicationController
  helper_method :current_column

  def index
    authorize(Topic)
    set_page_and_extract_portion_from policy_scope(current_column.topics), ordered_by: {created_at: :desc, id: :desc}
  end

  def new
    authorize(current_board, :show?)
    @topic = current_column.topics.new
  end

  def create
    authorize(current_board, :show?)
    @topic = current_column.topics.new(topic_params)

    if @topic.save
      current_board.broadcast_prepend_later_to(
        current_board,
        target: view_context.dom_id(current_column, :topics),
        html: Topic::Component.new(topic: @topic).render_in(view_context)
      )
      redirect_to new_board_column_topic_path(current_board, current_column), notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def current_board
    @board ||= Board.find(params[:board_id])
  end

  def current_column
    @column ||= current_board.columns.find(params[:column_id])
  end

  def topic_params
    params.require(:topic).permit(:name)
  end
end
