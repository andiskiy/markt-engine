# == Schema Information
#
#  Table name: purchases
#  id          :integer   not null, primary key
#  user_id     :integer
#  created_at  :datetime  not null
#  updated_at  :datetime  not null
#  status      :integer   default(0)
#

class Purchase < ApplicationRecord
  PER_PAGE = 50
  STATUSES = %w[pending processing completed].freeze
  enum status: STATUSES

  # Associations
  belongs_to :user
  has_many :orders

  # Validations
  validates :user_id, presence: true

  # Methods
  def amount
    orders.inject(0.0) { |sum, order| sum + order.item.price }
  end

  def datetime_format(str_time)
    str_time.in_time_zone(Time.zone.name).strftime(MarktEngine::DATETIME_FORMAT)
  end

  STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  def complete!
    update(status: 'completed')
  end
end
