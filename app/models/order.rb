class Order < ApplicationRecord
  # Associations
  belongs_to :item
  belongs_to :purchase
  belongs_to :user
end
