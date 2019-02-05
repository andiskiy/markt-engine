class MarktEngine.AdminOrdersIndex extends MarktEngine.Searchable
  @init: ->
    purchaseId = $('.orders-list').data('purchase-id')
    @setElements('.order-searchbar', '.orders-list', "/admin/purchases/#{purchaseId}/orders")
    super
