class Admin::UserPolicy < ApplicationPolicy
  def index?
    user.admin_or_higher?
  end

  def show?
    index? && record.admin_or_lower?
  end

  def update?
    show? && user.id != record.id
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
