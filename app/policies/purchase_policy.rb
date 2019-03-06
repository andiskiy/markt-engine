class PurchasePolicy < ApplicationPolicy
  def edit?
    record.pending? && record.orders.present?
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
