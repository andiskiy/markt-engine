class MarktEngine.CategoriesShow
  @init: ->
    @bind()

  @bind: ->
    $('.searchbar').on 'keyup', (e) =>
      changeIcon()
      @seachItems(1)
    $('.search-icon').on 'click', '.fa-times', (e) =>
      $('.searchbar').val('')
      changeIcon()
      @seachItems(1)
    $('.items-list').on 'click', '.pagination a', (e) =>
      e.preventDefault()
      page = $(e.target).attr('href').match(/page=\d+/)[0].replace('page=', '')
      @seachItems(page)

  @seachItems: (page) ->
    input =  $('.searchbar')
    value = input.val()
    return if (input.data('prev-value') == value && input.data('prev-value') == page) || input.data('request') == true
    setDataPrevAttributes(input, value, page)
    $.ajax
      type: 'GET',
      url: '/items',
      data: { category_id: $('.items-list').data('category-id'), value: value, page: page },
      success: (htmlItems) =>
        $('.items-list').html(htmlItems)
        input.attr('data-request', false)

  changeIcon= ->
    searchIcon = $('.search-icon')
    if $('.searchbar').val().length > 0
      searchIcon.find('.fa-search').removeClass('fa-search').addClass('fa-times')
    else
      searchIcon.find('.fa-times').removeClass('fa-times').addClass('fa-search')


  setDataPrevAttributes= (input, value, page) ->
    input.attr('data-prev-value', value)
    input.attr('data-prev-page', page)
    input.attr('data-request', true)