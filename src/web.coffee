retrieve = require('./retrieve')

module.exports = (port=3000, books) ->
  express = require('express')
  app = express()

  app.use express.static(__dirname + '/../public')

  app.get '/data.json', (req, res) ->
    retrieve(books).then (data) ->
      res.send data
    .fail (err) -> res.send(500, err: err)

  console.log "Starting web server on port #{port}...".green
  app.listen(port)
