class PurchasePolicy < ApplicationPolicy
  def update?
    record.pending? && record.orders.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
