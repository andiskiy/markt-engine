$url = null
$inputClass = null
$dataListClass = null

class MarktEngine.Searchable
  @init: ->
    @bind()

  @setElements: (inputClass, dataList, url) ->
    $url = url
    $inputClass = inputClass
    $dataListClass = dataList

  @bind: ->
    $($inputClass).on 'keyup', (e) =>
      changeIcon($inputClass)
      @seachItems(1, $inputClass)
    $('.search-icon').on 'click', '.fa-times', (e) =>
      $($inputClass).val('')
      changeIcon($inputClass)
      @seachItems(1, $inputClass)
    $($dataListClass).on 'click', '.pagination a', (e) =>
      e.preventDefault()
      page = $(e.target).attr('href').match(/page=\d+/)[0].replace('page=', '')
      @seachItems(page, $inputClass)

  @seachItems: (page, inputClass) ->
    input =  $(inputClass)
    value = input.val()
    return if statusRequest(input, value, page)
    setDataPrevAttributes(input, value, page)
    $.ajax
      type: 'GET',
      url: $url,
      dataType: 'html',
      data: { category_id: $($dataListClass).data('category-id'), value: value, page: page, format: 'js' },
      success: (itemsList) =>
        $($dataListClass).html(itemsList)
        input.attr('data-request', 'false')

  changeIcon= (input) ->
    searchIcon = $('.search-icon')
    if $(input).val().length > 0
      searchIcon.find('.fa-search').removeClass('fa-search').addClass('fa-times')
    else
      searchIcon.find('.fa-times').removeClass('fa-times').addClass('fa-search')

  setDataPrevAttributes= (input, value, page) ->
    input.attr('data-prev-value', value)
    input.attr('data-prev-page', page)
    input.attr('data-request', 'true')

  statusRequest= (input, value, page) ->
    (input.attr('data-prev-value') == value && input.attr('data-prev-page') == "#{page}") ||
      input.attr('data-request') == 'true'
