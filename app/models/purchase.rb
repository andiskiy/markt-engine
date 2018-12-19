class Purchase < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :orders

  # Methods
  def amount
    orders.inject(0.0) { |sum, order| sum + order.item.price }
  end
end
