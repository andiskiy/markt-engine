class Purchase < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  def amount
    total_amount = 0.0
    orders.each{|order| total_amount += order.item.price}
    total_amount
  end

end