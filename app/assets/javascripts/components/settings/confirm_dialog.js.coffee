class MarktEngine.ConfirmDialog
  @init: ->
    @setElements()
    @prepareMessageModal()

  @setElements: ->
    @messageModal  = $('#message-modal')

  @showMessageModal: (message, confirm = true) ->
    dataDismiss = @messageModal.find('[data-dismiss]')
    @messageModal.find('.message').text(message)

    if confirm
      @messageModal.find('.js-confirm').show()
      dataDismiss.text(dataDismiss.data('btn-text'))
    else
      @messageModal.find('.js-confirm').hide()
      dataDismiss.text('OK')

    @messageModal.modal 'show'

  @prepareMessageModal: ->
    @messageModal.modal
      show: false

    @messageModal.find('.js-confirm').on 'click', ->
      $.rails.confirmed(this)

    $.rails.allowAction = (link) ->
      return true unless link.attr('data-confirm')
      $.rails.showConfirmDialog(link)
      false

    $.rails.confirmed = =>
      $.rails.confirmLink.removeAttr('data-confirm')
      $.rails.confirmLink.trigger('click.rails')
      @messageModal.modal 'hide'

    $.rails.showConfirmDialog = (link) =>
      @messageModal.find('.js-confirm').text(link.data('continue')) if link.data('continue')
      @messageModal.find('.js-confirm').addClass(link.data('class')) if link.data('class')
      @showMessageModal(link.attr('data-confirm'))
      $.rails.confirmLink = link
