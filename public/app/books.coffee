class Book
  constructor: ({_id, isbn, title, author, prices, image, url}) ->
    @_id = rx.cell(_id)
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
    return [] unless p.length
    _(p).pluck 'value'

books = rx.array()

addBookForm = form {
  action: API_URLs.addBook
  method: 'POST'
  submit: (event) ->
    event.preventDefault()
    $.ajax
      url: $(@).attr 'action'
      method: $(@).attr 'method'
      data:
        isbn: => $(@).find('[name=isbn]').val().replace('-', '')
    .success (data) ->
      # response: {book: <Book>, user: <User>}
      addAlert type: 'success', msg: "Added #{data.book.title or data.book.isbn}"
      books.push new Book(data.book)
    .error (err) ->
      # response: {err: <String>}
      addAlert type: 'danger', msg: err.responseText
}, [
  input type: 'text', name: 'isbn', placeholder: 'ISBN'
  input type: 'submit', class: 'btn', value: 'Add'
]

booksTable = do ->
  toEUR = (value=0) ->
    text = "#{(value / 100).toFixed(2)}€"

    if value > 100
      return strong {style: 'color: green;'}, text
    if value > 10
      return strong text
    else
      return span text

  table {
    class: 'table'
  }, [
    thead [
      tr [
        th 'ISBN'
        th 'Title'
        th 'Value'
      ]
    ]
    tbody books.map (book, index) ->
      res = tr {
        class: 'book'
      }, [
        td book.isbn.get()
        td book.title.get()
        td [
          span [toEUR book.currentPrice()]
          span {class: 'line'}, book.pricesList().join(',')
        ]
        td [
          button {
            class: 'btn btn-danger remove'
            'data-book_id': book._id.get()
            'data-index': index
          }, '×'
        ]
      ]

      res.find('.line').peity("line")

      res
  ]

$ ->
  $(document).on 'click', '.book .remove', (event) ->
    btn = $(@)
    btn.attr disabled: true
    $.ajax
      url: API_URLs.removeBook
      method: 'POST'
      data:
        book_id: btn.data('book_id')
    .then ->
      btn.attr disabled: false
      books.removeAt btn.data('index')
    .fail ->
      btn.attr disabled: false
      addAlert type: 'danger', msg: 'Error removing book'