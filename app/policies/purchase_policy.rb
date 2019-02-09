class PurchasePolicy < ApplicationPolicy
  def update?
    user.can_make_order? && record.pending? && record.orders.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
