class RenameCountColumnForOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :count, :purchase_id
  end
end
