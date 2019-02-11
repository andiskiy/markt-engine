class MarktEngine.UserModal
  @init: ->
    @setElements()
    @bind()

  @setElements: () ->
    @modal = $('#show-user-modal')

  @bind: ->
    $('body').on 'click', '.js-show-user', (e) =>
      @openModal($(e.target).attr('href'))
      false
    @modal.on 'hidden.bs.modal', @clearModal

  @openModal: (href) =>
    @modal.find('.modal-content').load(href)
    @modal.modal('show')

  @clearModal: ->
    modal = $(this)
    modal.removeData('bs.modal')
    modal.find('.modal-content').html('')
