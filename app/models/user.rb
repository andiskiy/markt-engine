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
  validates :country_code, :address, :city, :zip_code, :phone, presence: true, on: :update

  # Scopes
  scope :order_by_id, -> { order(id: :asc) }
  scope :with_role, lambda { |role|
    User.roles[role] ? where(role: role) : where.not(role: nil)
  }
  scope :search, lambda { |value|
    where("CONCAT(first_name,' ',last_name) ILIKE :value OR
           email ILIKE :value", value: "%#{value}%")
  }

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_with_email(date)
    "#{old_first_name(date)} #{old_last_name(date)} (#{old_email(date)})"
  end

  def full_address
    full_address_exists? ? [address, city, country, zip_code].join(', ') : I18n.t('admin.user.messages.no_address')
  end

  def country
    return unless country_code

    country_name = ISO3166::Country[country_code]
    country_name.translations[I18n.locale.to_s] || country_name.name
  end

  private

  def full_address_exists?
    address.present? && city.present? && country_code.present? && zip_code.present?
  end
end
