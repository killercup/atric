log = require("#{__dirname}/../../src/log")

Book = require("#{__dirname}/../model/book")

module.exports = {}

module.exports.getBooks =
  spec:
    path: '/api/books'
    method: 'GET'
    summary: "Returns a list of books"
    description: "Returns a collection of books. By default, the ones the current user has added to her collection with just the most recent value as `lastprice`."
    example: """{
      "books": [
        {
          "__v": 0,
          "_id": "5208dc8611c41bddec000003",
          "author": "Scott McBain",
          "isbn": "9783426624760",
          "title": "Der Judasfluch",
          "lastprice": 10
        }
      ]
    }"""
    params:
      ids:
        type: 'String'
        summary: "Comma separated list of book ids. Only the books matching these IDs will be returned."
        example: "?ids=520b95fb7dcae0e2b83139de,52224a69dd7614b8c532718b"
      all:
        type: 'Bool'
        summary: "Return all books instead of the ones the current user has in her collection. Can be overwritten by `ids`."
      prices:
        type: 'String'
        summary: "`no`: Omnit all prices information.\n\n`all`: Return all prices.\n\n`latest`: Return latest value as `lastprice` field."
        default: 'latest'
      value_gt:
        type: 'Number'
        summary: "Filter books by minimum value (in cents)."
module.exports.getBooks.action = (req, res) ->
  options = {}
  select = amazon: 0

  # params
  prices = req.param('prices')
  all = req.param('all')
  ids = req.param('ids')
  value_gt = req.param('value_gt')

  if value_gt
    options["prices.value"] = "$gt": value_gt

  if ids
    options["_id"] = "$in": ids.split(',')
  else if req.user and not all
    options["_id"] = "$in": req.user.books

  if prices is 'no'
    select.prices = 0
  else if prices is 'all'
    # don't change field selection
  else
    # default: prices is 'latest'
    lastprice = true
    select.prices = "$slice": -1

  Book.find(options, select)
  .exec()
  .then (data) ->
    if lastprice
      books = data.map (b) ->
        book = b.toObject()
        book.lastprice = book.prices?[0]?.value
        delete book.prices
        book
    else books = data

    res.send books: books
  .then null, (err, info) ->
    res.send 500, err: err, msg: info

module.exports.getBook =
  spec:
    path: '/api/books/:id'
    method: 'GET'
    summary: "Returns a single book"
    description: "Returns a collection of books. By default, the ones the current user has added to her collection with just the most recent value as `lastprice`."
    params:
      id:
        type: 'String'
        summary: "Book ID"

module.exports.getBook.action = (req, res) ->
  id = req.param 'id'
  res.send 400, err: 'Specify book ID' unless id

  Book.findOne(_id: id).exec()
  .then (data) ->
    if not data?
      return res.send 404, err: "No book with such ID."

    res.send book: data
  .then null, (err) ->
    res.send 500, err: err

