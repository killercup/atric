Q = require('q')

log = require("#{__dirname}/../../src/log")
Book = require("#{__dirname}/../model/book")

module.exports = {}

module.exports.doRefresh = doRefresh = ->
  Book.find().select('isbn').exec()
  .then (books) ->
    Q.allSettled books.map (book) -> Book.fetchFromAmazon.call(Book, book)


module.exports.postRefresh =
  spec:
    path: '/api/refresh'
    method: "POST"
    summary: "Fetch new information from Amazon."
    needsAuth: true

module.exports.postRefresh.action = (req, res) ->
  doRefresh()
  .then (data) ->
    log.verbose "Books updated".green
    res.send data
  .then null, (err) ->
    log.verbose "Error updating books:".red, err
    res.send(500, err: err)
