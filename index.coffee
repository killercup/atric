yaml = require('js-yaml')
argv = require('optimist').argv

books = require './books.yml'

retrieve = require('./src/retrieve')

do ->
  console.log "Using books.yml with #{books.books.length} ISBNs"
  r = retrieve(books.books)

  if argv.table
    output = require('./src/tableOutput')
    output r

  out = argv.o or argv.out
  if typeof out is "string"
    fs = require('fs')

    r.then (data) ->
      fs.writeFile out, JSON.stringify(data, null, 2), (err) ->
        return console.log "Error writing file #{out}: #{err}" if err
        console.log "Wrote data to #{out}"
