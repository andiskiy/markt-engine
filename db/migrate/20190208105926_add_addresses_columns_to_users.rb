class AddAddressesColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country_code,:string
    add_column :users, :city,:string
    add_column :users, :address,:string
    add_column :users, :zip_code,:string
    add_column :users, :phone,:string
  end
end
