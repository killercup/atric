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

BookSchema.statics.getUserByIsbn = (isbn) ->
  @findOne(isbn: isbn).exec()

BookSchema.statics.fetchFromAmazon = (book) ->
  retrieve.fetchFromAmazon(book.isbn)
  .then ({title, value}) =>
    @update {isbn: book.isbn},
      title: title
      $push:
        prices:
          value: value
          date: Date.now()
    .exec()

module.exports = mongoose.model('Book', BookSchema)