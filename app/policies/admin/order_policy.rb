class Admin::OrderPolicy < ApplicationPolicy
  def index?
    user.admin? && record.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
