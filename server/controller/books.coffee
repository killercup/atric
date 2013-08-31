log = require("#{__dirname}/../../src/log")

Book = require("#{__dirname}/../model/book")

module.exports = {}
module.exports.books = (req, res) ->
  options = {}
  select = amazon: 0

  if req.param 'value_gt'
    options["prices.value"] = "$gt": req.param('value_gt')

  if req.user and not req.param('all')
    options["_id"] = "$in": req.user.books

  if req.param 'no_prices'
    select.prices = 0
  else if req.param 'all_prices'
    # don't change field selection
  else
    select.prices = "$slice": -1

  Book.find(options, select).exec()
  .then (data) ->
    res.send books: data
  .then null, (err) ->
    res.send 500, err: err

module.exports.book = (req, res) ->
  id = req.param 'id'
  res.send 400, err: 'Specify book ID' unless id

  Book.findOne(_id: id).exec()
  .then (data) ->
    res.send book: data
  .then null, (err) ->
    res.send 500, err: err