# == Schema Information
#
#  Table name: users
#  id                      :integer   not null, primary key
#  first_name              :string
#  last_name               :string
#  email                   :string
#  password                :string
#  role                    :integer   default(2)
#  created_at              :datetime  not null
#  updated_at              :datetime  not null
#  encrypted_password      :string   default(''), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer   default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  deleted_at              :datetime
#

class User < ApplicationRecord
  include User::Roles
  include Versionable

  PER_PAGE = 50

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_paranoid

  has_paper_trail on:   :update,
                  only: %i[first_name last_name email]

  versionable :first_name, :last_name, :email

  # Associations
  has_many :orders
  has_many :items, through: :orders
  has_many :purchases

  # Validations
  validates :first_name, :last_name, presence: true
  validates :role, inclusion: { in: User::ROLES }

  # Scopes
  scope :order_by_id, -> { order(id: :asc) }
  scope :with_role, lambda { |role|
    User.roles[role] ? where(role: role) : where.not(role: nil)
  }

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_with_email(date)
    "#{old_first_name(date)} #{old_last_name(date)} (#{old_email(date)})"
  end
end
