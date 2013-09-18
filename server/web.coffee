colors = require('colors')
yaml = require('js-yaml')

express = require('express')
mongoose = require('mongoose')

log = require('../src/log')

CONFIG = require("#{__dirname}/../_config.yml")
CONFIG._path = "#{__dirname}/../"

db = mongoose.connection

db.on 'open', ->
  log 'Connected to MongoDB'.green

db.on 'error', (err) ->
  log.error 'Mongo connection error!'.red, err

try
  mongoose.connect "mongodb://#{CONFIG.mongo.host}/#{CONFIG.mongo.db}"
  log.verbose "Started connection on to MongoDB, waiting for it to open...".grey
catch err
  log.error 'Could not connect to Mongo!'.red, err


module.exports = (port) ->
  port or= process.env.PORT || CONFIG.express.port
  app = express()

  app.set 'app config', CONFIG

  require("#{__dirname}/middlewares")(app)
  require("#{__dirname}/routes")(app)

  log "Starting web server on port #{port}...".green
  app.listen(port, '127.0.0.1')
