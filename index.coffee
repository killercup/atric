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

argv = optimist.argv

yaml = require('js-yaml')

books = require('./books.yml')

retrieve = require('./src/retrieve')

do ->
  if argv.h or argv.help
    return optimist.showHelp()

  console.log "Using books.yml with #{books.books.length} ISBNs".grey

  table = argv.t or argv.table
  if table
    options = {}
    options[i] = 1 for i in table.split?(',') if typeof table is "string"
    options.skipBelow = argv.skipBelow

    output = require('./src/tableOutput')
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
    server = require('./src/web.coffee')
    server(port, books.books)
