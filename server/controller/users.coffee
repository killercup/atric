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

module.exports.destroy = (req, res) ->
  req.user.remove (err) ->
    res.send 500, err: err if err
    res.send 200, msg: 'User deleted.'

module.exports.backup = (req, res) ->
  return res.send 401, err: "Not signed in" unless req.user

  User.findOne(_id: req.user._id).select('-twitter.token -twitter.tokenSecret')
  .populate('books', '-prices')
  .exec()
  .then (user) ->
    res.send user: user
  .then null, (err) ->
    res.send 500, err: err
