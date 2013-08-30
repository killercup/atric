express = require('express')

MongoStore = require('connect-mongo')(express)
passport = require('passport')

ejs = require('ejs')
ejs.open = '[%'
ejs.close = '%]'

module.exports = (app) ->
  app.configure ->
    app.use express.cookieParser()
    app.use express.bodyParser()

    app.use express.session
      secret: app.get('app config').express.sessionSecret
      store: new MongoStore
        db: app.get('app config').mongo.db

    app.use passport.initialize()
    app.use passport.session()

    app.engine 'html', ejs.__express

    app.use app.router
    app.use express.static app.get('app config')._path + app.get('app config').express.public
    return

  return app