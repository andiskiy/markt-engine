class MarktEngine.ItemsIndex extends MarktEngine.Searchable
  {CartOperation} = MarktEngine

  @init: ->
    CartOperation.init()
    @setElements('.searchbar', '.items-list', '/items')
    super


class MarktEngine.ItemsShow extends MarktEngine.AdminItemsShow
  {CartOperation} = MarktEngine

  @init: ->
    CartOperation.init()
    super
