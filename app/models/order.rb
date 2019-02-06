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

  # Validations
  validates :user_id, :item_id, :purchase_id, presence: true

  # Scopes
  scope :search, ->(value) { joins(:item).where('items.name ILIKE :value', value: "%#{value}%") }
end
