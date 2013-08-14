Q = require('q')

log = require("#{__dirname}/../../log")
Book = require("#{__dirname}/../model/book")

module.exports = {}
module.exports.postRefresh = (req, res) ->
  Book.find().select('isbn').exec()
  .then (books) ->
    Q.allSettled books.map (book) -> Book.fetchFromAmazon.call(Book, book)
  .then (data) ->
    log.verbose "Books updated".green
    res.send data
  .then null, (err) ->
    log.verbose "Error updating books:".red, err
    res.send(500, err: err)
