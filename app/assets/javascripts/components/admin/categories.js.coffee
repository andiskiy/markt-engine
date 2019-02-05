class MarktEngine.AdminCategoriesIndex
  @init: ->
    @bind()

  @bind: ->
    $('#accordion-categories').on 'click', '.load-more:not([disabled])', @loadModeData
    $('.category-searchbar').on 'keyup', (e) =>
      MarktEngine.Searchbar.changeIcon('.category-searchbar')
      @searchCategories(1)
    $('.search-icon').on 'click', '.fa-times', (e) =>
      $('.category-searchbar').val('')
      MarktEngine.Searchbar.changeIcon('.category-searchbar')
      @searchCategories(1)
    $('#accordion-categories').on 'click', '.pagination a', (e) =>
      e.preventDefault()
      page = $(e.target).attr('href').match(/page=\d+/)[0].replace('page=', '')
      @searchCategories(page)

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

  @searchCategories: (page) ->
    input = $('.category-searchbar')
    value = input.val()
    return if MarktEngine.Searchbar.statusRequest(input, value, page)
    MarktEngine.Searchbar.setDataPrevAttributes(input, value, page)
    $.ajax
      type: 'GET',
      url: '/admin/categories',
      dataType: 'html',
      data: { value: value, page: page, format: 'js' },
      success: (categoriesList) =>
        $('#accordion-categories').html(categoriesList)
        input.attr('data-request', 'false')
