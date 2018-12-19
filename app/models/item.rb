class Item < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :item_photos
  has_many :users, through: :orders
  has_many :orders

  accepts_nested_attributes_for :item_photos
end
