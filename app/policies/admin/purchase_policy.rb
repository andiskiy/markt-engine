class Admin::PurchasePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def complete?
    index? && record.processing?
  end

  def destroy?
    index?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
