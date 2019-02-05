class MarktEngine.CategoriesShow extends MarktEngine.Searchable
  @init: ->
    @setElements('.searchbar', '.items-list', '/items')
    super
