class AddedAddressesColumnsToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :country_code, :string
    add_column :purchases, :city, :string
    add_column :purchases, :address, :string
    add_column :purchases, :zip_code, :string
    add_column :purchases, :phone, :string
  end
end
