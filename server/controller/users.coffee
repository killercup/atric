passport = require('passport')

log = require("#{__dirname}/../../src/log")

User = require("#{__dirname}/../model/user")

module.exports = {}

passport.serializeUser (user, done) ->
  log.verbose "serializeUser"
  done null, user.id

passport.deserializeUser (id, done) ->
  log.verbose "deserializeUser"

  User.findOne(_id: id)
  .select('-twitter.token -twitter.tokenSecret')
  .exec (err, user) ->
    log.verbose "deserializeUser done", user
    done err, user


module.exports.ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  return res.send 401, err: "Not signed in" if req.is('json')
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
