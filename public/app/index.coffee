$ ->
  $('#actions').append do ->
    div [
      refreshButton
      signInButton
      addBookForm
    ]

  $('#main').append booksTable

  getMe()
  .success -> $('#loading-init').remove()
