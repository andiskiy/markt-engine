class Admin::CategoryPolicy < ApplicationPolicy
  def index?
    user.admin_or_higher?
  end

  def show?
    index?
  end

  def new?
    index?
  end

  def edit?
    index?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index? && record.items.blank?
  end

  def move_items?
    index?
  end

  def update_items?
    index?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
