class Purchase < ApplicationRecord
  STATUSES = %w[pending processing completed].freeze
  enum status: STATUSES

  # Associations
  belongs_to :user
  has_many :orders

  # Methods
  def amount
    orders.inject(0.0) { |sum, order| sum + order.item.price }
  end

  STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end
end
