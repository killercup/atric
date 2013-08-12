log = require("#{__dirname}/../../log")

Book = require("#{__dirname}/../model/book")

module.exports = {}
module.exports.books = (req, res) ->
  Book.find().exec()
  .then (data) ->
    res.send books: data
  .then null, (err) ->
    res.send 500, err: err