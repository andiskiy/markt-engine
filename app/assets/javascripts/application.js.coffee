#= require rails-ujs
#= require activestorage
#= require turbolinks
#= require jquery3
#= require popper
#= require bootstrap-sprockets
#= require_self
#= require cable.js
#= require_tree ./components/settings
#= require_tree ./components

window.MarktEngine = {}

class MarktEngine.Application
  @init: ->
    MarktEngine.DisabledLinks.init()
    MarktEngine.GlobalTooltips.init()
    MarktEngine.TurbolinksAdditions.init()

ready = ->
  data       = $('body').data()
  page       = data.page
  controller = data.controller

  MarktEngine.Application.init()
  MarktEngine[page].init() if MarktEngine[page]?

  controller.split('_').concat('').reduce (sum, part) ->
    MarktEngine[sum].init() if MarktEngine[sum]
    "#{sum}_#{part}"

$(document).on('turbolinks:load', ready)
