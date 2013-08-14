passport = require('passport')
TwitterStrategy = require('passport-twitter').Strategy

log = require("#{__dirname}/../../log")

User = require("#{__dirname}/../model/user")
Book = require("#{__dirname}/../model/book")

passport.use new TwitterStrategy {
    consumerKey: "SxEejPESBoFmLZJtVzk9wQ"
    consumerSecret: "MRPY7Qv7vNI6VCvZcANdO4nFIpRPNDeFPYT25d3pA"
    callbackURL: "http://127.0.0.1:3000/auth/twitter/callback"
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
  User.findOne(_id: id).select('-twitter').exec (err, user) ->
    log.verbose "deserializeUser done", user
    done err, user


module.exports = {}

module.exports.authenticateViaTwitter = passport.authenticate('twitter')

module.exports.TwitterAuth = passport.authenticate('twitter', failureRedirect: '/?auth=nope')

module.exports.authenticateViaTwitterSuccess = (req, res) ->
  log.verbose "Successful authentication, redirect home."
  res.redirect '/'

module.exports.ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect '/'

module.exports.logout = (req, res) ->
  req.logout()
  res.redirect '/'

module.exports.me = (req, res) ->
  res.send user: req.user

module.exports.addBook = (req, res) ->
  isbn = req.param 'isbn'
  return res.send 400, err: "Missing ISBN number" unless isbn?.length

  return res.send 400, err: "Not signed in" unless req.user

  newBook = {}

  Book.findOneAndUpdate({isbn: isbn}, {isbn: isbn}, {upsert: true})
  .exec()
  # .then null, (err) -> throw "Error creating your book"
  .then (book) ->
    console.log "book exec"

    b = Book.fetchFromAmazon(book)
    console.log "fetched", b, b.then
    b.then -> console.log arguments

  # .then null, (err) -> throw "Error loading book from Amazon"
  .then (book) ->
    # console.log "book fetch", arguments
    newBook = book
    # console.log 'new book', book, book._id
    User.findOneAndUpdate {_id: req.user.id},
      $push:
        books:
          id: book._id
    .exec()
  # .then null, (err) -> throw "Error adding your book"
  .then (user) ->
    res.send 200, book: newBook, user: user
  .then null, (err) -> return res.send 500, err: err
