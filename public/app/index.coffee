bind = rx.bind
rxt.importTags()

DATA_URL = '/data.json'

class Book
  constructor: ({isbn, title, author, value, image, url}) ->
    @isbn = rx.cell(isbn)
    @title = rx.cell(title)
    @author = rx.cell(author)
    @value = rx.cell(value)
    @image = rx.cell(image)
    @url = rx.cell(url)

books = rx.array()

$ ->
  $alerts = $ '#alerts'
  addAlert = ({msg, type}) ->
    $alerts.append div {class: 'alert alert-#{type}'}, [
      button {type: 'button', class: 'close'}, ['&times;']
      msg
    ]

  $('#main').append do ->
    # table = rxt.mktag('table')
    # thead = rxt.mktag('thead')
    # th = rxt.mktag('th')
    # tbody = rxt.mktag('tbody')
    # tr = rxt.mktag('tr')
    # td = rxt.mktag('td')

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
        tr [
          td book.isbn.get()
          td book.title.get()
          td [toEUR book.value.get()]
        ]
    ]

  $.getJSON(DATA_URL)
  .success (data) ->
    $('#loading-init').remove()

    _.each data.errors, (err) ->
      addAlert msg: err, type: 'warning'

    _.each data.books, (book) ->
      books.push new Book(book)
  .error (err) ->
    addAlert msg: err, type: 'warning'
