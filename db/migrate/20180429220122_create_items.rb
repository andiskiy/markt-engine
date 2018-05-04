class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string  :name
      t.text    :description
      t.float   :price
      t.integer :category_id
    end
  end
end
