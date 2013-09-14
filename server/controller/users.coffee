passport = require('passport')
TwitterStrategy = require('passport-twitter').Strategy

log = require("#{__dirname}/../../src/log")

CONFIG = require("#{__dirname}/../../_config.yml")

User = require("#{__dirname}/../model/user")
Book = require("#{__dirname}/../model/book")

passport.use new TwitterStrategy {
    consumerKey: CONFIG.twitter.consumerKey
    consumerSecret: CONFIG.twitter.consumerSecret
    callbackURL: "#{CONFIG.baseURL}/api/auth/twitter/callback"
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

  User.findOne(_id: id).select('-twitter.token -twitter.tokenSecret')
  # .populate('books')
  .exec (err, user) ->
    log.verbose "deserializeUser done", user
    done err, user


module.exports = {}

module.exports.ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  return res.send 401, err: "Not signed in" if req.is('json')
  res.redirect '/'

module.exports.authenticateViaTwitter =
  spec:
    path: '/api/auth/twitter'
    method: 'GET'
    summary: "Sign in using Twitter OAuth"
    description: "Redirects user to Twitter API"
  action: passport.authenticate('twitter')

module.exports.TwitterAuth = passport.authenticate('twitter', failureRedirect: '/?auth=nope')

module.exports.authenticateViaTwitterSuccess =
  spec:
    path: '/api/auth/twitter/callback'
    method: 'GET'
    summary: 'Twitter calls this with new user token'
  middlewares: [module.exports.TwitterAuth]

module.exports.authenticateViaTwitterSuccess.action = (req, res) ->
  log.verbose "Successful authentication, redirect home."
  return res.send msg: "Authentication successful" if req.is('json')
  res.redirect '/'

module.exports.logout =
  spec:
    path: '/api/logout'
    method: "GET"
    summary: "Deletes current users session"
    needsAuth: true

module.exports.logout.action = (req, res) ->
  req.logout()
  return res.send msg: "Logged Out" if req.is('json')
  res.redirect '/'

module.exports.getMe =
  spec:
    path: '/api/users/me'
    method: "GET"
    summary: "Returns current user"
    example: """{
      "user": {
        "_id": "520a4e1b7dcae0e2b83139dc",
        "name": "killercup",
        "books": [
          "5208dc8611c41bddec000003",
        ],
        "twitter": {
          "id": "1337"
        }
      }
    }"""
    needsAuth: true

module.exports.getMe.action = (req, res) ->
  res.send user: req.user


module.exports.destroyMe =
  spec:
    path: '/api/users/me'
    method: "DELETE"
    summary: "Deletes current user account."
    needsAuth: true

module.exports.destroyMe.action = (req, res) ->
  req.user.remove (err) ->
    res.send 500, err: err if err
    res.send 200, msg: 'User deleted.'


module.exports.backMeUp =
  spec:
    path: '/api/users/me/backup'
    method: "GET"
    summary: "Returns backup of current users account"
    description: "This includes the raw database record, except that `twitter.token` and `twitter.tokenSecret` have been stripped out."
    needsAuth: true

module.exports.backMeUp.action = (req, res) ->
  return res.send 401, err: "Not signed in" unless req.user

  User.findOne(_id: req.user._id).select('-twitter.token -twitter.tokenSecret')
  .populate('books', '-prices')
  .exec()
  .then (user) ->
    res.send user: user
  .then null, (err) ->
    res.send 500, err: err
