log = require("#{__dirname}/../../src/log")

CONFIG = require("#{__dirname}/../../_config.yml")

User = require("#{__dirname}/../model/user")
Book = require("#{__dirname}/../model/book")

module.exports = {}

module.exports.addBook = (req, res) ->
  return res.send 401, err: "Not signed in" unless req.user

  isbn = req.param('isbn') || req.body?.book?.isbn
  return res.send 400, err: "Missing ISBN number" unless isbn?.length

  addedBook = {}

  Book.findOneAndUpdate({isbn: isbn}, {isbn: isbn}, {upsert: true})
  .exec()
  # .then null, (err) -> throw new Error "Error creating your book"
  .then (book) ->
    addedBook = book

    Book.fetchFromAmazon(addedBook)
  # .then null, (err) -> throw new Error "Error loading book from Amazon"
  .then (book) ->
    addedBook = book
    User.findOneAndUpdate {_id: req.user.id},
      $push:
        books:
          _id: addedBook._id
    .exec()
  # .then null, (err) -> throw new Error "Error adding your book"
  .then (user) ->
    res.send 201, book: addedBook#, user: req.user
  .then null, (err) ->
    res.send 500, err: err

module.exports.removeBook = (req, res) ->
  book_id = req.param('book_id') || req.body?.book?.id
  return res.send 400, err: "Missing Book ID" unless book_id?.length

  User.findOneAndUpdate {_id: req.user.id},
    $pull:
      books: book_id
  .exec()
  .then (user) ->
    res.send 201, user: user
  .then null, (err) ->
    res.send 500, err: err

