class AddOrderedAtToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :ordered_at, :datetime
  end
end
