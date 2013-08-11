yaml = require('js-yaml')
Table = require('cli-table')

books = require '../books.yml'

retrieve = require('./retrieve')

do ->
  console.log "Using books.yml with #{books.books.length} ISBNs"

  table = new Table
    head: ["ISBN", "Title", "Value"]

  retrieve(books.books).then (data) ->
    for isbn, {title, author, value} of data
      table.push [isbn, title, value]

    console.log table.toString()
