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

  console.log "Using books.yml with #{books.books.length} ISBNs"

  if argv.t or argv.table
    output = require('./src/tableOutput')
    output retrieve(books.books)

  out = argv.o or argv.out
  if typeof out is "string"
    fs = require('fs')

    retrieve(books.books).then (data) ->
      fs.writeFile out, JSON.stringify(data, null, 2), (err) ->
        return console.log "Error writing file #{out}: #{err}" if err
        console.log "Wrote data to #{out}"
