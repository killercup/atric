colors = require('colors')
yaml = require('js-yaml')

express = require('express')
mongoose = require('mongoose')

log = require('../src/log')

CONFIG = require("#{__dirname}/../_config.yml")
CONFIG._path = "#{__dirname}/../"

mongoose.connect "mongodb://#{CONFIG.mongo.host}/#{CONFIG.mongo.db}", ->
  console.log 'Connected to Mongo'.grey

module.exports = (port) ->
  port or= process.env.PORT || CONFIG.express.port
  app = express()

  app.set 'app config', CONFIG

  require("#{__dirname}/middlewares")(app)
  require("#{__dirname}/routes")(app)

  console.log "Starting web server on port #{port}...".green
  app.listen(port)
