class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :count

      t.timestamps
    end
  end
end
