Q = require('q')
mongoose = require('mongoose')

log = require("#{__dirname}/../../log")

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
  author:
    type: String
    trim: true
  prices: [{
    value: Number
    date: Date
  }]
  amazon:
    url: String
    image: String

BookSchema.statics.findByIsbn = (isbn) ->
  @findOne(isbn: isbn).exec()

BookSchema.statics.fetchFromAmazon = (book) ->
  retrieve.fetchFromAmazon(book.isbn)
  .then ({title, value, author, url, image}) =>
    log.verbose "received #{book.isbn}, now updating as #{title}"
    @findOneAndUpdate {isbn: book.isbn},
      title: title
      author: author
      amazon:
        url: url
        image: image
      $push:
        prices:
          value: value
          date: Date.now()
    .exec()

module.exports = mongoose.model('Book', BookSchema)