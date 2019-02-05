class MarktEngine.AdminCategoriesIndex
  @init: ->
    @bind()

  @bind: ->
    $('#accordion-categories').on 'click', '.load-more:not([disabled])', @loadModeData

  @loadModeData: (e) ->
    loadMore = $((e.target))
    return if loadMore.data('request') == true
    setRequestAttributes(loadMore)
    $.ajax
      type: 'GET',
      url:"/admin/categories/#{loadMore.data('category-id')}/items",
      dataType: 'html',
      data: { page: loadMore.data('next-page'), format: 'js' },
      success: (itemsList) ->
        itemListTag = loadMore.closest('.items-list')
        loadMore.closest('li').remove()
        itemListTag.append(itemsList)
        loadMore.attr('data-request', false)

  setRequestAttributes= (loadMore) ->
    loadMore.attr('disabled', true)
    loadMore.find('i').removeClass('fa-arrow-down').addClass('fa-spinner fa-spin')
    loadMore.attr('data-request', true)
