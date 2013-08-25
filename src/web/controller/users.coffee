passport = require('passport')
TwitterStrategy = require('passport-twitter').Strategy

log = require("#{__dirname}/../../log")

CONFIG = require("#{__dirname}/../../../_config.yml")

User = require("#{__dirname}/../model/user")
Book = require("#{__dirname}/../model/book")

passport.use new TwitterStrategy {
    consumerKey: CONFIG.twitter.consumerKey
    consumerSecret: CONFIG.twitter.consumerSecret
    callbackURL: "http://127.0.0.1:3000/api/auth/twitter/callback"
  }, (token, tokenSecret, profile, done) ->
    User.findOneAndUpdate { 'twitter.id': profile.id }, {
      name: profile.username
      twitter:
        id: profile.id
        token: token
        tokenSecret: tokenSecret
    }, {upsert: true}, (err, user) ->
      done(err, user)

passport.serializeUser (user, done) ->
  log.verbose "serializeUser"
  done null, user.id

passport.deserializeUser (id, done) ->
  log.verbose "deserializeUser"

  User.findOne(_id: id).select('-twitter')
  # .populate('books')
  .exec (err, user) ->
    log.verbose "deserializeUser done", user
    done err, user


module.exports = {}

module.exports.authenticateViaTwitter = passport.authenticate('twitter')

module.exports.TwitterAuth = passport.authenticate('twitter', failureRedirect: '/?auth=nope')

module.exports.authenticateViaTwitterSuccess = (req, res) ->
  log.verbose "Successful authentication, redirect home."
  return res.send msg: "Authentication successful" if req.is('json')
  res.redirect '/'

module.exports.ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  return res.send 401, err: "Not signed in" if req.is('json')
  res.redirect '/'

module.exports.logout = (req, res) ->
  req.logout()
  return res.send msg: "Logged Out" if req.is('json')
  res.redirect '/'

module.exports.me = (req, res) ->
  res.send user: req.user

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
