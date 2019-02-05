class MarktEngine.CategoriesShow
  @init: ->
    @bind()

  @bind: ->
    $('.searchbar').on 'keyup', (e) =>
      MarktEngine.Searchbar.changeIcon('.searchbar')
      @seachItems(1)
    $('.search-icon').on 'click', '.fa-times', (e) =>
      $('.searchbar').val('')
      MarktEngine.Searchbar.changeIcon('.searchbar')
      @seachItems(1)
    $('.items-list').on 'click', '.pagination a', (e) =>
      e.preventDefault()
      page = $(e.target).attr('href').match(/page=\d+/)[0].replace('page=', '')
      @seachItems(page)

  @seachItems: (page) ->
    input =  $('.searchbar')
    value = input.val()
    return if MarktEngine.Searchbar.statusRequest(input, value, page)
    MarktEngine.Searchbar.setDataPrevAttributes(input, value, page)
    $.ajax
      type: 'GET',
      url: '/items',
      data: { category_id: $('.items-list').data('category-id'), value: value, page: page },
      success: (itemsList) =>
        $('.items-list').html(itemsList)
        input.attr('data-request', 'false')
