class MarktEngine.AdminItemsIndex extends MarktEngine.Searchable
  @init: ->
    @setElements('.item-searchbar', '.items-list', '/admin/items')
    super

class MarktEngine.AdminItemsAllItems extends MarktEngine.AdminItemsIndex
