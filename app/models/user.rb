class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :orders
  has_many :items, through: :orders
  has_many :purchases

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    role.zero?
  end
end
