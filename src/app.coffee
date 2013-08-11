yaml = require('js-yaml')
colors = require('colors')
Table = require('cli-table')

books = require '../books.yml'

retrieve = require('./retrieve')

do ->
  console.log "Using books.yml with #{books.books.length} ISBNs"

  table = new Table
    head: ["ISBN", "Title", "Value"]

  retrieve(books.books).then (data) ->
    for isbn, {title, author, value} of data
      price = "EUR #{(value / 100).toFixed(2)}"
      if value > 10 then price = price.underline.green
      table.push [isbn, title, price]

    console.log table.toString()
