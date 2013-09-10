BookController = require("#{__dirname}/controller/books")
UserController = require("#{__dirname}/controller/users")
RefreshController = require("#{__dirname}/controller/refresh")

module.exports = (app) ->
  app.get '/', (req, res) ->
    res.render "#{app.get('app config')._path}#{app.get('app config').express.public}/index.html",
      req: req
      config: app.get('app config')
      minify: if app.get('app config').environment isnt 'development' then '.min' else ''

  app.get '/api/auth/twitter', UserController.authenticateViaTwitter
  app.get '/api/auth/twitter/callback', UserController.TwitterAuth, UserController.authenticateViaTwitterSuccess
  app.delete '/api/auth', UserController.ensureAuthenticated, UserController.logout
  app.get '/api/logout', UserController.ensureAuthenticated, UserController.logout

  app.get '/api/users/me', UserController.ensureAuthenticated, UserController.me
  app.get '/api/users/me/backup', UserController.ensureAuthenticated, UserController.backup
  app.post '/api/users/addBook', UserController.ensureAuthenticated, UserController.addBook
  app.post '/api/users/removeBook', UserController.ensureAuthenticated, UserController.removeBook

  app.get '/api/books', BookController.books
  app.get '/api/books/:id', BookController.book
  app.post '/api/books', UserController.ensureAuthenticated, UserController.addBook
  app.delete '/api/books', UserController.ensureAuthenticated, UserController.removeBook
  app.delete '/api/books/:book_id', UserController.ensureAuthenticated, UserController.removeBook

  app.post '/api/refresh', RefreshController.postRefresh

  return app