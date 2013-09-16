passport = require('passport')
TwitterStrategy = require('passport-twitter').Strategy

log = require("#{__dirname}/../../src/log")

CONFIG = require("#{__dirname}/../../_config.yml")
User = require("#{__dirname}/../model/user")

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

module.exports = {}

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
