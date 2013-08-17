User =
  name: rx.cell()
  _id: rx.cell()
  update: (options) ->
    for key, value of options
      this[key]?.set(value)

signInButton = #bind ->
  if User._id.get()
    a {
      class: 'btn btn-danger'
      id: 'logout'
      href: API_URLs.logout
      click: (event) ->
        event.preventDefault()
        $.ajax
          url: API_URLs.logout
          method: 'DELETE'
        .success (data) ->
          User.name.set(null)
          User._id.set(null)
    }, 'Log Out'
  else
    a {
      class: 'btn btn-success'
      id: 'signin'
      href: API_URLs.authWithTwitter
    }, 'Sign In'

getMe = ->
  $.getJSON(API_URLs.getMe)
  .success (data) ->
    User.update name: data.user.name, _id: data.user._id

    arr = data.user.books.map (book) -> new Book(book)
    books.replace arr
  .error (err) ->
    addAlert msg: err.responseText, type: 'warning'

refreshButton = button {
  class: 'btn btn-primary'
  click: ->
    btn = $(@)
    btn.attr disabled: true
    $.ajax
      url: '/refresh'
      method: 'POST'
    .then ->
      getMe().then ->
        btn.attr disabled: false
}, 'Refresh'
