class MarktEngine.Searchbar
  @changeIcon: (input) ->
    searchIcon = $('.search-icon')
    if $(input).val().length > 0
      searchIcon.find('.fa-search').removeClass('fa-search').addClass('fa-times')
    else
      searchIcon.find('.fa-times').removeClass('fa-times').addClass('fa-search')

  @setDataPrevAttributes: (input, value, page) ->
    input.attr('data-prev-value', value)
    input.attr('data-prev-page', page)
    input.attr('data-request', 'true')

  @statusRequest: (input, value, page) ->
    (input.attr('data-prev-value') == value && input.attr('data-prev-page') == "#{page}") ||
      input.attr('data-request') == 'true'