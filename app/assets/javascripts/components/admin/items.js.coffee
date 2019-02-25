class MarktEngine.AdminItemsIndex extends MarktEngine.Searchable
  @init: ->
    @setElements('.item-searchbar', '.items-list', '/admin/items')
    super

class MarktEngine.AdminItemsAllItems extends MarktEngine.AdminItemsIndex

class MarktEngine.AdminItemsNew
  @init: ->
    @bind()

  @bind: ->
    $('.radio').on 'click', ->
      $('.radio').not(this).prop('checked', false)
    $('body').on 'change', '.image-input', @previewPhoto
    $('body').on 'click', '.label-items:not(.add-image)', ->
      setMainCurrentPhoto($(this))
      false
    $('.delete-image').on 'click', ->
      label = $(this).closest('.label-items')
      label.find('.remove_photo_checkbox').prop('checked', true)
      deletePreviewPhoto(label)
      setMainDefaultPhoto(label.find('.radio'))
      false


  @previewPhoto: ->
    label = $(this).closest('.label-items')
    if (this.files && this.files[0])
      reader = new FileReader()
      reader.onload = (e) ->
        label.find('.remove_photo_checkbox').prop('checked', false)
        label.find('.photo-items').attr('src', e.target.result).removeClass('d-none')
        label.find('.image-input').addClass('d-none')
        label.find('.delete-image').removeClass('d-none')
        label.find('.radio').removeAttr('disabled')
        label.removeClass('add-image')
      reader.readAsDataURL(this.files[0])

  deletePreviewPhoto= (label) ->
    input = label.find('.image-input')
    label.find('.photo-items').removeAttr('src').addClass('d-none')
    label.find('.delete-image').addClass('d-none')
    input.removeClass('d-none')
    input.val('')
    label.addClass('add-image')

  setMainDefaultPhoto= (radio) ->
    radio.prop('checked', false)
    radio.attr('disabled', true)
    if $('.label-items:not(.add-image)').length > 0
      firstLabel = $($('.label-items:not(.add-image)')[0])
      otherRadio = firstLabel.find('.radio')
      otherRadio.prop('checked', true)
      otherRadio.trigger('click')

  setMainCurrentPhoto= ($this) ->
    radio = $this.find('.radio')
    radio.prop('checked', true)
    radio.trigger('click')
    $('.photo-items').removeClass('img-thumbnail')
    $this.find('.photo-items').addClass('img-thumbnail')


class MarktEngine.AdminItemsShow
  @init: ->
    @setElements()
    @bind()

  @setElements: ->
    @modal = $('#show-image-modal')

  @bind: ->
    $('.slider').bxSlider()
    $('.photo').on 'click', (e) =>
      @openModal($(e.target).attr('src'))
      false
    @modal.on 'hidden.bs.modal', @clearModal

  @openModal: (src) ->
    @modal.find('.modal-content img').attr('src', src)
    @modal.modal('show')

  @clearModal: ->
    $(this).find('.modal-content img').removeAttr('src')

class MarktEngine.AdminItemsCreate extends MarktEngine.AdminItemsNew

class MarktEngine.AdminItemsEdit extends MarktEngine.AdminItemsNew

class MarktEngine.AdminItemsUpdate extends MarktEngine.AdminItemsEdit
