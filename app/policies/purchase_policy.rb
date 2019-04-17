class PurchasePolicy < ApplicationPolicy
  def edit?
    record.pending? && record.orders.joins(:item).present? && user.id == record.user_id
  end

  def update?
    edit?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
