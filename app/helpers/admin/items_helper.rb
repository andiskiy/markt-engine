module Admin::ItemsHelper
  def category_name(category)
    return category.name unless all_items?

    content_tag :span do
      concat link_to(category.name, admin_category_items_path(category))
    end
  end

  private

  def all_items?
    action_name == 'all_items'
  end
end
