Q = require('q')

log = require("#{__dirname}/../../log")
Book = require("#{__dirname}/../model/book")

getBooks = ->
  deferred = Q.defer()

  # doesn't use Q, so...
  Book.find().select('isbn').exec (err, data) ->
    return deferred.reject(err) if err?
    deferred.resolve(data)

  return deferred.promise

module.exports = {}
module.exports.postRefresh = (req, res) ->
  getBooks()
  .then (books) ->
    deferred = Q.defer()

    Q.allSettled(books.map(Book.fetchFromAmazon))
    .then (data) ->
      deferred.resolve books
    .fail (err) ->
      deferred.reject err

    return deferred.promise

  .then (data) ->
    log.verbose "Books updated".green
    res.send data
  .then null, (err) ->
    log.verbose "Error updating books:".red, err
    res.send(500, err: err)
