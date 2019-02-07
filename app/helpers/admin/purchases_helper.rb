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
end
