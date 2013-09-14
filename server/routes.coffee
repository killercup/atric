Book = require("#{__dirname}/controller/books")
User = require("#{__dirname}/controller/users")
Library = require("#{__dirname}/controller/library")
Refresh = require("#{__dirname}/controller/refresh")


module.exports = (app) ->
  Static = require("#{__dirname}/controller/static")(app)

  needsAuth = User.ensureAuthenticated

  routes =
    getIndexHTML: Static.getIndexHTML

    authenticateViaTwitter: User.authenticateViaTwitter
    authenticateViaTwitterSuccess: User.authenticateViaTwitterSuccess
    logout: User.logout
    getMe: User.getMe
    backMeUp: User.backMeUp
    destroyMe: User.destroyMe

    getBooks: Book.getBooks
    getBook: Book.getBook

    addBook: Library.addBook
    removeBook: Library.removeBook
    avgValueOverTime: Library.avgValueOverTime

    postRefresh: Refresh.postRefresh

  ###
  # Build Routes

  For each entry in `routes`, add an API endpoint to express.
  ###
  for k, v of routes
    unless (v?.spec?.path? or v.spec?.method? or v.action?)
      err = ['Incorrect route spec', k, v]
      throw err

    # 'GET' -> 'get', to be used as `app['method']`
    method = v.spec.method.toLowerCase()

    # will be something along the lines of
    # `['/path', middleware1, middleware2, requestHandler]`
    args = []

    args.push v.spec.path

    args.push needsAuth if v.spec.needsAuth
    if v.middlewares
      args.push m for m in v.middlewares

    args.push v.action

    app[method].apply app, args

  # Server API index/documentation
  app.get '/api', (req, res) ->
    if req.is('json') or req.param('format') is 'json'
      return res.send routes: _.map(routes, 'spec')

    res.render "#{__dirname}/api.html",
      routes: routes
      marked: require('marked')
      _: require('lodash')

  return app