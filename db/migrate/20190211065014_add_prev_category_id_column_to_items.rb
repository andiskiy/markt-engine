class AddPrevCategoryIdColumnToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :prev_category_id, :integer
  end
end
