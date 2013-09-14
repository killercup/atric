log = require("#{__dirname}/../../src/log")

CONFIG = require("#{__dirname}/../../_config.yml")

User = require("#{__dirname}/../model/user")
Book = require("#{__dirname}/../model/book")

module.exports = {}

module.exports.addBook =
  spec:
    path: '/api/books'
    method: "POST"
    summary: "Add book to current user's collection."
    description: "Adds a book by it's ISBN number. Event if the ISBN is already in the database, this will fetch the latest data from Amazon (it can be slow)."
    needsAuth: true
    params:
      isbn:
        type: 'Number'
        summary: "ISBN of the book to add"

module.exports.addBook.action = (req, res) ->
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

module.exports.removeBook =
  spec:
    path: '/api/books/:book_id'
    method: "DELETE"
    summary: "Remove book from current user's collection."
    description: "Removes a book by it's ID number. This will only remove the reference to the book in the user's entry, not any actual data about the book."
    needsAuth: true
    params:
      book_id:
        type: 'String'
        summary: "ID of the book to be removed"

module.exports.removeBook.action = (req, res) ->
  book_id = req.param('book_id') || req.body?.book?.id
  return res.send 400, err: "Missing Book ID" unless book_id?.length

  User.findOneAndUpdate {_id: req.user.id},
    $pull:
      books: book_id
  .exec()
  .then (user) ->
    res.send 204 #no content
  .then null, (err) ->
    res.send 500, err: err

module.exports.avgValueOverTime =
  spec:
    path: '/api/users/value-stats'
    method: "GET"
    summary: "Avarage value of book collection over time."
    description: "This will aggregate the value data of a collection of books on a per day basis. By default, this will use the current user's collection of books and summarize the value of the whole collection for the last 14 days."
    needsAuth: true
    params:
      per_book:
        type: 'Bool'
        summary: "Instead of a sum of the value of all books, return the day's value for each book."
        default: false
      min_value:
        type: 'Number'
        summary: "Skip values below that limit."
        default: 10
      limit_days:
        type: 'Number'
        summary: "Return data from now until this many days ago."
        default: 14

module.exports.avgValueOverTime.action = (req, res) ->
  users_books = req.user.books
  creation_date = new Date(req.user._id.getTimestamp())

  # params
  min_value = parseInt req.param('min_value'), 10
  per_book = req.param('per_book')
  limit_days = req.param('days') || 14

  match_users_books =
    $match:
      _id:
        $in: users_books

  unwind_prices =
    $unwind: "$prices"

  if min_value
    date_range =
      $match:
        'prices.date':
          $gte: creation_date
        'prices.value':
          $gte: min_value
  else
    date_range =
      $match:
        'prices.date':
          $gte: creation_date

  group_by_book_and_date_making_value_avg =
    $group:
      _id:
        book: "$_id"
        year:
          $year: "$prices.date"
        month:
          $month: "$prices.date"
        day:
          $dayOfMonth: "$prices.date"
      title:
        $first: "$title"
      value:
        $avg: "$prices.value"

  group_by_date_making_value_avg =
    $group:
      _id:
        year: "$_id.year"
        month: "$_id.month"
        day: "$_id.day"
      value:
        $sum: "$value"

  sort_by_date =
    $sort:
      '_id.year': -1
      '_id.month': -1
      '_id.day': -1

  last_days =
    $limit: limit_days

  process = (err, docs) ->
    return res.send 500, err: err if err
    return res.send 404, err: 'no results' unless docs.length

    res.send 200, data: docs

  if per_book
    Book.aggregate match_users_books,
      unwind_prices,
      date_range,
      group_by_book_and_date_making_value_avg,
      sort_by_date,
      last_days,
      process
  else
    Book.aggregate match_users_books,
      unwind_prices,
      date_range,
      group_by_book_and_date_making_value_avg,
      group_by_date_making_value_avg,
      sort_by_date,
      last_days,
      process
