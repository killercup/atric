colors = require('colors')
optimist = require('optimist')
  .usage('Amazon Trade In Price Check')
  .alias('o', 'out')
  .describe('o', 'Write data to JSON file. Usage: "-o data.json"')
  .alias('t', 'table')
  .describe('t', "Output results as CLI table. Can take comma-separated list of options (currently just 'nonEmpty').")
  .describe('skipBelow', "Don't show entries with a value below that number (in cents).")
  .alias('s', 'web')
  .describe('s', 'Start web server. Optional: --web=PORT (default port is 3000)')
  .alias('i', 'import')
  .describe('i', 'Import ISBNs from books.yml into MongoDB')
  .alias('r', 'refresh')
  .describe('r', 'Refresh pricing data in MongoDB')
  .describe('verbose', 'Show a bunch more log statements')

argv = optimist.argv

yaml = require('js-yaml')

books = require("#{__dirname}/books.yml")

retrieve = require("#{__dirname}/src/retrieve")
log = require("#{__dirname}/src/log")

do ->
  if argv.h or argv.help
    return optimist.showHelp()

  log.verbose "Using books.yml with #{books.books.length} ISBNs".grey

  table = argv.t or argv.table
  if table
    options = {}
    options[i] = 1 for i in table.split?(',') if typeof table is "string"
    options.skipBelow = argv.skipBelow

    output = require("#{__dirname}/src/tableOutput")
    output retrieve(books.books), options

  out = argv.o or argv.out
  if out
    if typeof out isnt "string"
      console.log "You need to specify a filename.".red
      return process.exit(1)
    fs = require('fs')

    retrieve(books.books).then (data) ->
      fs.writeFile out, JSON.stringify(data, null, 2), (err) ->
        if err
          console.log "Error writing file #{out}: #{err}".red
          return process.exit(1)

        console.log "Wrote data to #{out}".green

  web = argv.s or argv.web
  if web
    port = parseInt(web, 10) or 3000
    server = require("#{__dirname}/src/web.coffee")
    server(port)

  doImport = argv.i or argv.import
  if doImport
    console.log "Running import".green
    importer = require("#{__dirname}/src/import")
    importer.import(books.books).then (books) ->
      console.log "All done.".green
      process.exit(0)

  refresh = argv.r or argv.refresh
  if refresh
    console.log "Running refresh".green
    CONFIG = require("./_config.yml")

    mongoose = require('mongoose')
    RefreshController = require('./src/web/controller/refresh')

    mongoose.connect CONFIG.mongo.uri, ->
      log.verbose 'Connected to Mongo'.grey

    RefreshController.doRefresh()
    .then (data) ->
      log.verbose data
      console.log "#{data.length} Books updated".green
      process.exit(0)
    .then null, (err) ->
      console.log "Error updating books:".red, err
      process.exit(1)

  return
