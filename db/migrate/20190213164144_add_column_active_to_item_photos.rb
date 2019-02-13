class AddColumnActiveToItemPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :item_photos, :active, :boolean
  end
end
