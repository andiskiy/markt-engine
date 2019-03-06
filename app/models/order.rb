# == Schema Information
#
#  Table name: orders
#  id          :integer   not null, primary key
#  user_id     :integer
#  item_id     :integer
#  purchase_id :integer
#  created_at  :datetime  not null
#  updated_at  :datetime  not null
#  quantity    :integer   default(0)
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

  # Callbacks
  after_save :delete_order, if: -> { quantity <= 0 }

  # Scopes
  scope :search_with_deleted, lambda { |value|
    joins(:with_deleted_item).where('items.name ILIKE :value', value: "%#{value}%")
  }

  def increase!
    self.quantity += 1
    save
  end

  def decrease!
    self.quantity -= 1
    save
  end

  private

  def delete_order
    destroy
  end
end
