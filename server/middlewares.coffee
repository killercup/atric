express = require('express')

mongoose = require('mongoose')
MongoStore = require('connect-mongo')(express)
passport = require('passport')

ejs = require('ejs')
ejs.open = '[%'
ejs.close = '%]'

module.exports = (app) ->
  Static = require("#{__dirname}/controller/static")(app)

  app.configure 'development', ->
    app.use express.errorHandler
      dumpExceptions: true
      showStack: true

  app.configure ->
    app.use express.static app.get('app config')._path + app.get('app config').express.public

    app.use express.logger('dev')

    app.use express.cookieParser()
    app.use express.bodyParser()

    app.use express.session
      secret: app.get('app config').express.sessionSecret
      store: new MongoStore
        db: app.get('app config').mongo.db
        mongoose_connection: mongoose.connection

    app.use passport.initialize()
    app.use passport.session()

    app.engine 'html', ejs.__express

    app.use app.router

    app.use (req, res, next) ->
      # we landed here because no other resources matched that route, so we'll
      # serve the client side app which either has a handler for that or will
      # show a real 404.
      Static.getIndexHTML.action(req, res)

    app.use (err, req, res, next) ->
      console.log err
      if req.is 'json'
        res.send '500',
          status: err.status || 500
          error: err
          meme: "http://i.imgur.com/6NfmQ.jpg"
      else
        res.render "#{__dirname}/500.html",
          status: err.status || 500
          error: err
          meme: "http://i.imgur.com/6NfmQ.jpg"

    return

  return app