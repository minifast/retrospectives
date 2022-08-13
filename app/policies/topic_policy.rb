class TopicPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    TopicPolicy::Scope.new(user, Topic).resolve.exists?(id: record.id)
  end

  def create?
    user.present?
  end

  def update?
    show? && user.id == record.user_id
  end

  def destroy?
    show? && update?
  end

  class Scope < Scope
    def resolve
      scope.where(column_id: Column.where(board_id: BoardUser.where(user_id: user&.id).select(:board_id)).select(:column_id))
    end
  end
end
