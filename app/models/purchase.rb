# == Schema Information
#
#  Table name: purchases
#  id          :integer   not null, primary key
#  user_id     :integer
#  created_at  :datetime  not null
#  updated_at  :datetime  not null
#  status      :integer   default(0)
#  ordered_at  :datetime
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

  # Callbacks
  before_save :set_ordered_at, if: -> { status_changed? && processing? }

  # Scopes
  scope :with_orders, -> { joins(:orders).having('COUNT(orders.id) > 0').group('purchases.id') }
  scope :not_pending, -> { where('purchases.status <> ?', STATUSES.index('pending')) }

  class << self
    def with_status(status)
      status_matched?(status) ? where('purchases.status = ?', STATUSES.index(status)) : where.not(status: nil)
    end

    private

    def status_matched?(status)
      STATUSES.include?(status)
    end
  end

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

    define_method "#{status}!" do
      update(status: status)
    end
  end

  private

  def set_ordered_at
    self.ordered_at = Time.current
  end
end
