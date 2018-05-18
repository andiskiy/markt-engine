class CreateItemPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :item_photos do |t|
      t.integer :item_id
      t.string :photo
    end
  end
end
