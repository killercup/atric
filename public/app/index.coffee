bind = rx.bind
rxt.importTags()

API_URLs =
  authWithTwitter: '/auth/twitter'
  getMe: '/users/me'
  addBook: '/users/addBook'
  getBooks: '/books'

class Book
  constructor: ({isbn, title, author, prices, image, url}) ->
    @isbn = rx.cell(isbn)
    @title = rx.cell(title)
    @author = rx.cell(author)
    @prices = rx.cell(prices)
    @image = rx.cell(image)
    @url = rx.cell(url)

  currentPrice: ->
    len = @prices.get().length
    return unless len
    @prices.get()[len-1].value

  pricesList: ->
    p = @prices.get()
    return unless p.length
    _(p).pluck 'value'

books = rx.array()

$ ->
  $alerts = $ '#alerts'
  addAlert = ({msg, type}) ->
    $alerts.append div {class: "alert alert-#{type}"}, [
      # rawHtml('&times;')
      button {type: 'button', class: 'close', 'data-dismiss': 'alert'}, 'x'
      msg
    ]

  $('#actions').append do ->
    div [
      button {
        class: 'btn btn-primary'
        click: ->
          btn = $(@)
          btn.attr disabled: true
          $.ajax
            url: '/refresh'
            method: 'POST'
          .then ->
            refresh().then ->
              btn.attr disabled: false
      }, 'Refresh'
      a {
        class: 'btn btn-success'
        id: 'signin'
        href: API_URLs.authWithTwitter
      }, 'Sign In'
      form {
        action: API_URLs.addBook
        method: 'POST'
        submit: (event) ->
          event.preventDefault()
          $.ajax
            url: $(@).attr 'action'
            method: $(@).attr 'method'
            data: $(@).serialize()
          .success (data) ->
            # response: {book: <Book>, user: <User>}
            addAlert type: 'success', msg: "Added #{data.book.title}"
            books.push new Book(data.book)
          .error (err) ->
            # response: {err: <String>}
            addAlert type: 'danger', msg: err.responseText
      }, [
        input type: 'text', name: 'isbn', placeholder: 'ISBN'
        input type: 'submit', class: 'btn', value: 'Add'
      ]
    ]

  $('#main').append do ->

    toEUR = (value=0) ->
      text = "#{(value / 100).toFixed(2)}€"

      if value > 100
        return strong {style: 'color: green;'}, text
      if value > 10
        return strong text
      else
        return span text

    table {class: 'table'}, [
      thead [
        tr [
          th 'ISBN'
          th 'Title'
          th 'Value'
        ]
      ]
      tbody books.map (book) ->
        res = tr [
          td book.isbn.get()
          td book.title.get()
          td [
            span [toEUR book.currentPrice()]
            span {class: 'line'}, book.pricesList().join(',')
          ]
        ]

        res.find('.line').peity("line")

        res
    ]

  refresh = ->
    $.getJSON(API_URLs.getMe)
    .success (data) ->
      $('#signin').hide()

      arr = data.user.books.map (book) -> new Book(book)
      books.replace arr
    .error (err) ->
      addAlert msg: err.responseText, type: 'warning'

  refresh()
  .success -> $('#loading-init').remove()
