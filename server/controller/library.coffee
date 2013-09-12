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

module.exports.avgValueOverTime = (req, res) ->
  users_books = req.user.books
  creation_date = new Date(req.user._id.getTimestamp())

  match_users_books =
    $match:
      _id:
        $in: users_books

  unwind_prices =
    $unwind: "$prices"

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
    $limit: req.param('days') || 14

  process = (err, docs) ->
    return res.send 500, err: err if err
    return res.send 404, err: 'no results' unless docs.length

    res.send 200, data: docs

  if req.param('per_book')
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
