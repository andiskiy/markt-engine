class MarktEngine.DisabledLinks
  @init: ->
    $('a[disabled]').on 'click', (e) ->
      e.preventDefault()
      e.stopPropogation()
