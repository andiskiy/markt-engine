class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders
  has_many :items, through: :orders
  has_many :purchases

  before_create :set_role

  def is_admin?
    self.role == 0
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

  def set_role
    self.role = 1
  end

end