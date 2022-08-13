class TimerPolicy < ApplicationPolicy
  def index?
    !user.guest?
  end

  def show?
    user.board_ids.include?(record.board_id)
  end

  def create?
    !user.guest?
  end

  def update?
    show? && create?
  end

  def destroy?
    show? && create?
  end

  class Scope < Scope
    def resolve
      scope.where(board_id: BoardUser.where(user_id: user.id).select(:board_id))
    end
  end
end
