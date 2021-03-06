# == Schema Information
#
#  Table name: items
#  id          :integer   not null, primary key
#  name        :string
#  description :text
#  price       :float
#  category_id :integer
#  deleted_at  :datetime
#  created_at  :datetime  not null
#  updated_at  :datetime  not null
#

class Item < ApplicationRecord
  include Versionable
  PER_PAGE = 50

  acts_as_paranoid

  has_paper_trail on:   :update,
                  only: %i[name price]

  versionable :name, :price

  # Associations
  belongs_to :category
  belongs_to :prev_category, class_name: 'Category', optional: true
  has_many :item_photos, dependent: :destroy
  has_many :orders
  has_many :users, through: :orders
  has_many :pending_orders, lambda {
    joins(:purchase).where('purchases.status = ?', Purchase.statuses['pending'])
  }, class_name: 'Order', inverse_of: :item

  accepts_nested_attributes_for :item_photos, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :name, :price, presence: true

  # Callbacks
  after_destroy :delete_pending_orders

  # Scopes
  scope :order_by_name, -> { order(name: :asc) }
  scope :search, lambda { |value, category_id|
    items = where('name ILIKE :value', value: "%#{value}%").order_by_name
    category_id.present? ? items.where(category_id: category_id) : items
  }

  # Methods
  def active_photo
    item_photos.find_by(active: true)
  end

  def thumb_url
    active_photo.photo.thumb.url
  end

  def ensure_five_photos
    needed_photos_count.times { association(:item_photos).add_to_target(ItemPhoto.new) }
  end

  def order(purchase, user)
    orders.find_by(purchase: purchase, user: user)
  end

  private

  def needed_photos_count
    needed = 5 - item_photos.length
    needed.positive? ? needed : 0
  end

  # Callbacks
  def delete_pending_orders
    pending_orders.destroy_all
  end
end
