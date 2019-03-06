class MarktEngine.CategoriesShow extends MarktEngine.Searchable
  {CartOperation} = MarktEngine

  @init: ->
    CartOperation.init()
    @setElements('.searchbar', '.items-list', '/items')
    super
