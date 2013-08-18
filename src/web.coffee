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
    app.use express.cookieParser()
    app.use express.bodyParser()

    app.use express.session
      secret: 'asdasdhjasdsad162312dasnjds'
      store: new MongoStore
        db: "atric"

    app.use passport.initialize()
    app.use passport.session()

    app.engine 'html', require('ejs').__express

    app.use app.router
    app.use express.static(__dirname + '/../public')

  app.get '/', (req, res) -> res.render '../public/index.html', req: req

  app.get '/api/auth/twitter', UserController.authenticateViaTwitter
  app.get '/api/auth/twitter/callback', UserController.TwitterAuth, UserController.authenticateViaTwitterSuccess
  app.delete '/api/auth', UserController.ensureAuthenticated, UserController.logout
  app.get '/api/logout', UserController.ensureAuthenticated, UserController.logout

  app.get '/api/users/me', UserController.ensureAuthenticated, UserController.me
  app.post '/api/users/addBook', UserController.ensureAuthenticated, UserController.addBook
  app.post '/api/users/removeBook', UserController.ensureAuthenticated, UserController.removeBook

  app.get '/api/books', BookController.books
  app.get '/api/books/:id', BookController.book
  app.post '/api/books', UserController.ensureAuthenticated, UserController.addBook
  app.delete '/api/books/:book_id', UserController.ensureAuthenticated, UserController.removeBook

  app.post '/api/refresh', RefreshController.postRefresh

  console.log "Starting web server on port #{port}...".green
  app.listen(port)
