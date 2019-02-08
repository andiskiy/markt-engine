class MarktEngine.AdminUsersIndex extends MarktEngine.Searchable
  @init: ->
    @setElements('.user-searchbar', '#users-management', '/admin/users')
    @bind()

  @bind: ->
    $('#users-management').on 'click', '.user-role', @changeRole
    super

  @changeRole: (e) ->
    input = $(e.target)
    $.ajax
      type: 'PATCH',
      url: "/admin/users/#{input.data('user-id')}",
      dataType: 'json',
      data: { role: input.val() },
      success: (response) ->
        switch response.status
          when 'updated' then updated(input)
          when 'unprocessable_entity' then unprocessableEntity(input, response.errors)
          when 'not_authorized' then notAuthorized(input, response.error)

  updated= (input) ->
    input.closest('td').addClass('alert-success')
    setTimeout (->
      input.closest('td').removeClass('alert-danger')
    ), 3000

  unprocessableEntity= (input, errors) ->
    error_str = ''
    $.each(errors, (key, value) ->
      error_str += "#{key}: #{errors[key]}"
    )
    input.attr('title', error_str)
    input.closest('td').addClass('alert-danger')
    $(input.data('user-input')).prop('checked', true)
    setTimeout (->
      input.closest('td').removeClass('alert-danger')
    ), 7000

  notAuthorized= (input, error) ->
    input.prop('checked', false)
    input.attr('title', error)
