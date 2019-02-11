class MarktEngine.AdminCategoriesIndex extends MarktEngine.Searchable
  @init: ->
    @setElements('.category-searchbar', '#accordion-categories', '/admin/categories')
    @bind()

  @setElements: (inputClass, dataList, url) ->
    @modal = $('#move-items-modal')
    super(inputClass, dataList, url)

  @bind: ->
    $('#accordion-categories').on 'click', '.move-items', (e) =>
      @openModal($(e.target).closest('.actions').find('.move-items').attr('href'))
      false
    @modal.on 'hidden.bs.modal', @clearModal
    $('#accordion-categories').on 'click', '.load-more:not([disabled])', @loadModeData
    super

  @openModal: (href) =>
    @modal.find('.modal-content').load(href)
    @modal.modal('show')

  @clearModal: ->
    modal = $(this)
    modal.removeData('bs.modal')
    modal.find('.modal-content').html('')

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
