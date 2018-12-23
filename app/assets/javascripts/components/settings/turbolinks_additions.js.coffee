class MarktEngine.TurbolinksAdditions
  @init: ->
    @bind()
    @trackAnalytics()

  @bind: ->
    $('[data-no-turbolink-hard]').on 'click', @clearTurbolinksCache

  @clearTurbolinksCache: ->
    Turbolinks.pagesCached 0

  @trackAnalytics: ->
    window.ga? 'send', 'pageview',
      location: window.location.href.split('#')[0]
      title:    document.title
