# == Schema Information
#
#  Table name: orders
#  id          :integer   not null, primary key
#  user_id     :integer
#  item_id     :integer
#  purchase_id :integer
#  created_at  :datetime  not null
#  updated_at  :datetime  not null
#

class Order < ApplicationRecord
  PER_PAGE = 50

  # Associations
  belongs_to :item
  belongs_to :purchase
  belongs_to :user
  belongs_to :with_deleted_item, -> { with_deleted }, foreign_key: 'item_id',
                                                      inverse_of:  false,
                                                      class_name:  'Item',
                                                      optional:    true

  # Scopes
  scope :search_with_deleted, lambda { |value|
    joins(:with_deleted_item).where('items.name ILIKE :value', value: "%#{value}%")
  }
end
