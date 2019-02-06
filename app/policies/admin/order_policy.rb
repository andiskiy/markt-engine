class Admin::OrderPolicy < ApplicationPolicy
  def index?
    user.admin? && record.present? && !record.first.purchase.pending?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
