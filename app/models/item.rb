class Item < ActiveRecord::Base
  has_many :orders
  has_many :users, through:  :orders
  belongs_to :category


end