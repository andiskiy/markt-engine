class Admin::OrderPolicy < ApplicationPolicy
  def index?
    user.admin_or_higher? && record.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
