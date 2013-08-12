Q = require('q')
mongoose = require('mongoose')

retrieve = require("#{__dirname}/../../retrieve")

Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BookSchema = new Schema
  isbn:
    type: String
    index:
      unique: true
    required: true
    trim: true
  title:
    type: String
    trim: true
  prices: [{
    value: Number
    date: Date
  }]

Book = mongoose.model('Book', BookSchema)

Book.getUserByFbId = (isbn) ->
  Book.findOne(isbn: isbn).exec()

Book.fetchFromAmazon = (book) ->
  retrieve.fetchFromAmazon(book.isbn)
  .fail (err) ->
    console.log "error fetchFromAmazon", JSON.stringify err, null, 2
  .then ({title, value}) ->
    Book.update {isbn: book.isbn},
      title: title
      $push:
        prices:
          value: value
          date: Date.now()
    .exec()
  .then null, (err) ->
    console.log "error update book record", JSON.stringify err, null, 2

module.exports = Book
