module Admin::OrdersHelper
  def order_item(item, purchase, status = true)
    case status
    when item.deleted?
      content_tag(:div) do
        concat(content_tag(:i, class: 'fas fa-gift') {})
        concat(" #{item.old_name(purchase.ordered_at)}")
      end
    else
      content_tag(:a, href: admin_category_item_path(item.category, item)) do
        concat(content_tag(:i, class: 'fas fa-gift') {})
        concat(" #{item.old_name(purchase.ordered_at)}")
      end
    end
  end
end
