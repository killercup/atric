passport = require('passport')
TwitterStrategy = require('passport-twitter').Strategy

log = require("#{__dirname}/../../log")

User = require("#{__dirname}/../model/user")

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
  if req.user
    res.send user: req.user
  else
    res.send 204
