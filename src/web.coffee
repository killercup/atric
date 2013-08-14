colors = require('colors')
yaml = require('js-yaml')
Q = require('q')
passport = require('passport')

mongoose = require('mongoose')

CONFIG = require("#{__dirname}/../_config.yml")

retrieve = require("#{__dirname}/retrieve")

mongoose.connect CONFIG.mongo.uri, ->
  console.log 'Connected to Mongo'.grey

log = require('./log')

Book = require("#{__dirname}/web/model/book")

BookController = require('./web/controller/books')
UserController = require('./web/controller/users')
RefreshController = require('./web/controller/refresh')

module.exports = (port=3000) ->
  express = require('express')
  MongoStore = require('connect-mongo')(express)
  expressMongoose = require('express-mongoose')

  app = express()

  app.configure ->
    app.use express.static(__dirname + '/../public')
    app.use express.cookieParser()
    app.use express.bodyParser()

    app.use express.session
      secret: 'asdasdhjasdsad162312dasnjds'
      store: new MongoStore
        db: "atric"

    app.use passport.initialize()
    app.use passport.session()

    app.use app.router

  app.get '/auth/twitter', UserController.authenticateViaTwitter
  app.get '/auth/twitter/callback', UserController.TwitterAuth, UserController.authenticateViaTwitterSuccess

  app.get '/users/me', UserController.ensureAuthenticated, UserController.me
  app.post '/users/addBook', UserController.ensureAuthenticated, UserController.addBook
  app.post '/users/removeBook', UserController.ensureAuthenticated, UserController.removeBook

  app.get '/books', BookController.books
  app.post '/refresh', RefreshController.postRefresh

  console.log "Starting web server on port #{port}...".green
  app.listen(port)
