class AddCreatedAtAndUpdatedAtToItemPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :item_photos, :created_at, :datetime, null: false
    add_column :item_photos, :updated_at, :datetime, null: false
  end
end
