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
    @topic = current_column.topics.new(topic_params.merge(user: current_or_guest_user))

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

  def destroy
    authorize(current_topic)

    respond_to do |format|
      if current_topic.destroy
        current_board.broadcast_remove_to(current_board, target: view_context.dom_id(current_topic))
        format.turbo_stream { flash.now[:notice] = t('.success') }
        format.html { redirect_to board_column_topic_path(current_board, current_column, current_topic), notice: t('.success') }
      else
        format.html { redirect_to board_column_topic_path(current_board, current_column, current_topic) }
      end
    end
  rescue Pundit::NotAuthorizedError, ActiveRecord::RecordNotFound
    respond_to do |format|
      format.turbo_stream { flash.now[:alert] = t('.alert') }
      format.html { redirect_to board_timer_url(current_board), alert: t('.alert') }
    end
  end

  private

  def current_board
    @current_board ||= Board.find(params[:board_id])
  end

  def current_column
    @current_column ||= current_board.columns.find(params[:column_id])
  end

  def current_topic
    @current_topic ||= current_column.topics.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name)
  end
end
