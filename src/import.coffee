yaml = require('js-yaml')
CONFIG = require('../_config.yml')

Q = require('q')

mongoose = require('mongoose')

mongoose.connect "mongodb://#{CONFIG.mongo.host}/#{CONFIG.mongo.db}", ->
  console.log 'Connected to Mongo'.grey

log = require('./log')

Book = require("#{__dirname}/../server/model/book")

newBook = (isbn) ->
  deferred = Q.defer()

  book = new Book(isbn: isbn)
  book.save (err, item, numberAffected) ->
    return deferred.reject(err) if err?
    log.verbose "saved book for ISBN #{isbn}"
    deferred.resolve(item, numberAffected)

  return deferred.promise

module.exports = {}
module.exports.import =(books) ->
  books ||= require('./books.yml').books
  deferred = Q.defer()

  Q.allSettled(books.map(newBook))
  .then (books) ->
    books.forEach (promise) ->
      if promise.state is "fulfilled"
        val = promise.value
        log.verbose "Added #{val.isbn} (#{val.title})".green
      else
        log.verbose "There was a problem: #{promise.reason}".red

    deferred.resolve(books)
  .fail (err) ->
    console.log "not all settled", err

  return deferred.promise
