class Item < ActiveRecord::Base
  has_many :orders
  has_many :item_photos
  has_many :users, through:  :orders
  belongs_to :category

  accepts_nested_attributes_for :item_photos

end