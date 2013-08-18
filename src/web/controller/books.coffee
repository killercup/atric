log = require("#{__dirname}/../../log")

Book = require("#{__dirname}/../model/book")

module.exports = {}
module.exports.books = (req, res) ->
  options = {}
  if req.param 'value_gt'
    options = "prices.value": "$gt": req.param('value_gt')

  Book.find(options).exec()
  .then (data) ->
    res.send books: data
  .then null, (err) ->
    res.send 500, err: err