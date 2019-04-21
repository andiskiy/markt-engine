class User
  module Roles
    extend ActiveSupport::Concern

    included do
      ROLES = %w[super admin standard].freeze
      enum role: ROLES

      ROLES.each do |role|
        scope role, -> { where(role: role) }
        scope "#{role}_or_higher", -> { where('users.role <= ?', User.roles[role]) }
        scope "#{role}_or_lower", -> { where('users.role >= ?', User.roles[role]) }

        define_method "#{role}?" do
          self.role == role
        end

        define_method "#{role}_was?" do
          role_was == role
        end

        define_method "#{role}_or_higher?" do
          User.roles[self.role] <= User.roles[role]
        end

        define_method "#{role}_or_lower?" do
          User.roles[self.role] >= User.roles[role]
        end

        define_method "#{role}!" do
          update(role: role)
        end
      end
    end
  end
end
