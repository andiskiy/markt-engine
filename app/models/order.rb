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
  # Associations
  belongs_to :item
  belongs_to :purchase
  belongs_to :user

  # Validations
  validates :user_id, :item_id, :purchase_id, presence: true
end
