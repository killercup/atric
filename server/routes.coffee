Book = require("#{__dirname}/controller/books")
User = require("#{__dirname}/controller/users")
Library = require("#{__dirname}/controller/library")
Refresh = require("#{__dirname}/controller/refresh")

module.exports = (app) ->
  needsAuth = User.ensureAuthenticated

  app.get '/', (req, res) ->
    res.render "#{app.get('app config')._path}#{app.get('app config').express.public}/index.html",
      req: req
      config: app.get('app config')
      minify: if app.get('app config').environment isnt 'development' then '.min' else ''

  app.get '/api/auth/twitter', User.authenticateViaTwitter
  app.get '/api/auth/twitter/callback', User.TwitterAuth, User.authenticateViaTwitterSuccess
  app.delete '/api/auth', needsAuth, User.logout
  app.get '/api/logout', needsAuth, User.logout

  app.get '/api/users/me', needsAuth, User.me
  app.delete '/api/users/me', needsAuth, User.destroy
  app.get '/api/users/me/backup', needsAuth, User.backup
  app.post '/api/users/addBook', needsAuth, Library.addBook
  app.post '/api/users/removeBook', needsAuth, Library.removeBook

  app.get '/api/books', Book.books
  app.get '/api/books/:id', Book.book
  app.post '/api/books', needsAuth, Library.addBook
  app.delete '/api/books', needsAuth, Library.removeBook
  app.delete '/api/books/:book_id', needsAuth, Library.removeBook

  app.post '/api/refresh', Refresh.postRefresh

  return app