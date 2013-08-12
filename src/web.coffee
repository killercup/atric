colors = require('colors')
yaml = require('js-yaml')
Q = require('q')

mongoose = require('mongoose')
# mongoStore = require('connect-mongo')(express)
# expressMongoose = require('express-mongoose')

CONFIG = require("#{__dirname}/../_config.yml")

retrieve = require("#{__dirname}/retrieve")

mongoose.connect CONFIG.mongo.uri, ->
  console.log 'Connected to Mongo'.grey

log = require('./log')

Book = require("#{__dirname}/web/model/book")

module.exports = (port=3000) ->
  express = require('express')
  app = express()

  app.use express.static(__dirname + '/../public')

  app.get '/books.json', require('./web/controller/books').books
  app.post '/refresh', require('./web/controller/refresh').postRefresh

  console.log "Starting web server on port #{port}...".green
  app.listen(port)
