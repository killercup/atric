colors = require('colors')
optimist = require('optimist')
  .usage('Amazon Trade In Price Check')
  .alias('o', 'out')
  .describe('o', 'Write data to JSON file. Usage: "-o data.json"')
  .alias('t', 'table')
  .describe('t', 'Output results as CLI table')

argv = optimist.argv

yaml = require('js-yaml')

books = require('./books.yml')

retrieve = require('./src/retrieve')

do ->
  if argv.h or argv.help
    return optimist.showHelp()

  console.log "Using books.yml with #{books.books.length} ISBNs".grey

  if argv.t or argv.table
    output = require('./src/tableOutput')
    output retrieve(books.books)

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

  if argv.s or argv.web
    console.log "http server coming soon"
