# == Schema Information
#
#  Table name: purchases
#  id            :integer   not null, primary key
#  user_id       :integer
#  created_at    :datetime  not null
#  updated_at    :datetime  not null
#  status        :integer   default(0)
#  ordered_at    :datetime
#  country_code  :string
#  city          :string
#  address       :string
#  zip_code      :string
#  phone         :string
#

class Purchase < ApplicationRecord
  include Countryable

  PER_PAGE = 50
  STATUSES = %w[pending processing completed].freeze
  enum status: STATUSES

  # Associations
  belongs_to :user
  belongs_to :with_deleted_user, -> { with_deleted }, foreign_key: 'user_id',
                                                      inverse_of:  false,
                                                      class_name:  'User',
                                                      optional:    true
  has_many :orders

  # Validations
  validates :country_code, :address,
            :city, :zip_code, :phone, presence: true, if: -> { status_changed? && processing? }

  # Callbacks
  before_save :set_ordered_at, if: -> { status_changed? && processing? }

  # Scopes
  scope :with_orders, lambda {
    joins(orders: :with_deleted_item)
      .where('(purchases.status = :pending AND items.deleted_at IS NULL) OR
              (purchases.status <> :pending)', pending: Purchase.statuses['pending'])
      .having('COUNT(orders.id) > 0').group('purchases.id').order(created_at: :asc)
  }
  scope :not_pending, -> { where('purchases.status <> ?', Purchase.statuses['pending']) }

  class << self
    def with_status(status)
      status_matched?(status) ? where('purchases.status = ?', Purchase.statuses[status]) : where.not(status: nil)
    end

    private

    def status_matched?(status)
      Purchase.statuses[status]
    end
  end

  # Methods
  def amount_with_deleted_items
    orders.inject(0.0) { |sum, order| sum + (order.with_deleted_item.old_price(ordered_date) * order.quantity) }
  end

  def amount_items
    orders.joins(:item).inject(0) { |sum, order| sum + (order.item.price * order.quantity) }
  end

  def datetime_format(str_time)
    str_time.in_time_zone(Time.zone.name).strftime(MarktEngine::DATETIME_FORMAT)
  rescue NoMethodError
    'N/A'
  end

  def ordered_date
    time = ordered_at || Time.now.utc
    time.in_time_zone('UTC')
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
