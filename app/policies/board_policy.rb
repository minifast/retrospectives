class BoardPolicy < ApplicationPolicy
  def index?
    !user.guest?
  end

  def show?
    record.user_ids.include?(user.id)
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
      scope.where(id: BoardUser.where(user_id: user.id).select(:board_id))
    end
  end
end
