class AddStatusToPurchases < ActiveRecord::Migration[5.2]
  def change
    remove_column :purchases, :completed
    add_column :purchases, :status, :integer, default: 0
  end
end
