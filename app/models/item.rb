class Item < ApplicationRecord
  PER_PAGE = 50

  # Associations
  belongs_to :category
  has_many :item_photos
  has_many :users, through: :orders
  has_many :orders

  accepts_nested_attributes_for :item_photos

  class << self
    def search(value, category_id)
      items = Item.where('name ILIKE :value', value: "%#{value}%")
      category_id.present? ? items.where(category_id: category_id) : items
    end
  end
end
