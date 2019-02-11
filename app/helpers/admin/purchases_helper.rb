module Admin::PurchasesHelper
  def purchase_status(purchase, status = true)
    case status
    when purchase.completed?
      content_tag(:div, class: 'badge badge-success') do
        concat content_tag(:i, class: 'far fa-check-circle') {}
        concat(" #{t('admin.purchase.attributes.complete')}")
      end
    when purchase.pending?
      content_tag(:div, class: 'badge badge-warning') do
        concat(content_tag(:i, class: 'far fa-circle') {})
        concat(" #{t('admin.purchase.attributes.pending')}")
      end
    when purchase.processing?
      content_tag(:div, class: 'badge badge-primary') do
        concat(content_tag(:i, class: 'far fa-circle') {})
        concat(" #{t('admin.purchase.attributes.processing')}")
      end
    end
  end

  def customer(user, purchase, status = true)
    case status
    when user.deleted?
      content_tag(:div, class: 'inline-block') { user.full_name_with_email(purchase.ordered_date) }
    else
      content_tag(:a, href: admin_user_path(user), class: 'js-show-user') do
        user.full_name_with_email(purchase.ordered_date)
      end
    end
  end
end
