_ = require('lodash')

Book = require("#{__dirname}/controller/books")
User = require("#{__dirname}/controller/users")
Library = require("#{__dirname}/controller/library")
Refresh = require("#{__dirname}/controller/refresh")


module.exports = (app) ->
  # app.get '/api/books', (req, res, next) ->
  #   setTimeout next, 3000
  needsAuth = User.ensureAuthenticated

  routes =
    'getIndexHTML':
      spec:
        path: '/'
        method: "GET"
        summary: "Send index.html with client side application."
        needsAuth: true
      action: (req, res) ->
        res.render "#{app.get('app config')._path}#{app.get('app config').express.public}/index.html",
          req: req
    'authenticateViaTwitter':
      spec:
        path: '/api/auth/twitter'
        method: 'GET'
        summary: "Sign in using Twitter OAuth"
        description: "Redirects user to Twitter API"
      action: User.authenticateViaTwitter
    'authenticateViaTwitterSuccess':
      spec:
        path: '/api/auth/twitter/callback'
        method: 'GET'
        summary: 'Twitter calls this with new user token'
      middlewares: [User.TwitterAuth]
      action: User.authenticateViaTwitterSuccess
    'getMe':
      spec:
        path: '/api/users/me'
        method: "GET"
        summary: "Returns current user"
        needsAuth: true
      action: User.me
    'getBooks': Book.getBooks
    'getBook': Book.getBook

  for k, v of routes
    method = v.spec.method.toLowerCase()
    args = []

    args.push v.spec.path

    args.push needsAuth if v.spec.needsAuth
    for m in (v.middlewares or [])
      args.push m

    args.push v.action

    app[method].apply app, args

  # app.get '/api/auth/twitter', User.authenticateViaTwitter
  # app.get '/api/auth/twitter/callback', User.TwitterAuth, User.authenticateViaTwitterSuccess
  app.delete '/api/auth', needsAuth, User.logout
  app.get '/api/logout', needsAuth, User.logout

  # app.get '/api/users/me', needsAuth, User.me
  app.delete '/api/users/me', needsAuth, User.destroy
  app.get '/api/users/me/backup', needsAuth, User.backup
  app.post '/api/users/addBook', needsAuth, Library.addBook
  app.post '/api/users/removeBook', needsAuth, Library.removeBook
  app.get '/api/users/value-stats', needsAuth, Library.avgValueOverTime

  # app.get '/api/books', Book.books
  # app.get '/api/books/:id', Book.book
  app.post '/api/books', needsAuth, Library.addBook
  app.delete '/api/books', needsAuth, Library.removeBook
  app.delete '/api/books/:book_id', needsAuth, Library.removeBook

  app.post '/api/refresh', Refresh.postRefresh

  app.get '/api', (req, res) ->
    res.send routes: _.map(routes, 'spec')

  return app