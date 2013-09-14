module.exports = (app) ->
  routes = {}
  routes.getIndexHTML =
    spec:
      path: '/'
      method: "GET"
      summary: "Send index.html with client side application."
    action: (req, res) ->
      res.render "#{app.get('app config')._path}#{app.get('app config').express.public}/index.html",
        req: req

  routes
