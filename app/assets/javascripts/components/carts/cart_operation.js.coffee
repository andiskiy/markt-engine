class MarktEngine.CartOperation
  @init: ->
    @bind()

  @bind: ->
    $('.items-list').on 'click', '.add-item a.item-button', @addItem
    $('.items-list').on 'click', '.plus-minus .item-plus', @addItem
    $('.items-list').on 'click', '.plus-minus .item-minus', @deleteItem

  @addItem: (e) ->
    item = $(e.target).closest('.item')
    $.ajax
      type: 'POST',
      url: '/orders',
      dataType: 'json',
      data: { item_id: item.attr('data-item-id') },
      success: (response) ->
        switch response.status
          when 'created' then created(item, response)
          when 'unprocessable_entity' then unprocessableEntity(item)

  @deleteItem: (e) ->
    item = $(e.target).closest('.item')
    $.ajax
      type: 'DELETE',
      url: "/orders/#{item.attr('data-order-id')}",
      dataType: 'json',
      data: { item_id: item.attr('data-item-id') },
      success: (response) ->
        switch response.status
          when 'deleted' then deleted(item, response)
          when 'unprocessable_entity' then unprocessableEntity(item)


  created= (item, response) ->
    if item.find('.plus-minus.d-none').length > 0
      item.find('.plus-minus').removeClass('d-none')
      item.find('.add-item').addClass('d-none')
      item.attr('data-order-id', response.order.id)
    item.find('.quantity').html(response.order.quantity)
    $('nav .items-price').html(response.purchase.amount)

  deleted= (item, response) ->
    if response.order.quantity <= 0
      if item.find('.add-item.d-none').length > 0
        item.find('.plus-minus').addClass('d-none')
        item.find('.add-item').removeClass('d-none')
      else
        item.closest('.item-column').remove()
    item.find('.quantity').html(response.order.quantity)
    $('nav .items-price').html(response.purchase.amount)

  unprocessableEntity= (item) ->
    item.find('.item-action').addClass('alert-danger')
    setTimeout (->
      item.find('.item-action').removeClass('alert-danger')
    ), 5000
