class MarktEngine.AdminItemsIndex extends MarktEngine.Searchable
  @init: ->
    @setElements('.item-searchbar', '.items-list', '/admin/items')
    super

class MarktEngine.AdminItemsAllItems extends MarktEngine.AdminItemsIndex

class MarktEngine.AdminItemsNew
  @init: ->
    @bind()

  @bind: ->
    $('body').on 'change', '.image-input', @previewPhoto
    $('body').on 'click', '.label-items:not(.add-image)', ->
      false
    $('.delete-image').on 'click', ->
      label = $(this).closest('.label-items')
      label.find('.remove_photo_checkbox').prop('checked', true)
      deletePreviewPhoto(label)
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
        label.removeClass('add-image')
      reader.readAsDataURL(this.files[0])

  deletePreviewPhoto= (label) ->
    input = label.find('.image-input')
    label.find('.photo-items').removeAttr('src').addClass('d-none')
    label.find('.delete-image').addClass('d-none')
    input.removeClass('d-none')
    input.val('')
    label.addClass('add-image')

class MarktEngine.AdminItemsCreate extends MarktEngine.AdminItemsNew

class MarktEngine.AdminItemsEdit extends MarktEngine.AdminItemsNew

class MarktEngine.AdminItemsUpdate extends MarktEngine.AdminItemsEdit
