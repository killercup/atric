bind = rx.bind
rxt.importTags()

DATA_URL = '/books.json'

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
    $alerts.append div {class: 'alert alert-#{type}'}, [
      button {type: 'button', class: 'close'}, ['&times;']
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
    $.getJSON(DATA_URL)
    .success (data) ->
      _.each data.errors, (err) ->
        addAlert msg: err, type: 'warning'

      arr = data.books.map (book) -> new Book(book)
      books.replace arr
    .error (err) ->
      addAlert msg: err, type: 'warning'

  refresh()
  .success -> $('#loading-init').remove()
