class AddCreatedAtAndUpdatedAtToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :created_at, :datetime, null: false
    add_column :categories, :updated_at, :datetime, null: false
  end
end
