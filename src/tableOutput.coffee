colors = require('colors')
Table = require('cli-table')

module.exports = (retrieve) ->
  table = new Table
    head: ["ISBN", "Title", "Value"]

  retrieve.then (data) ->
    return console.log "Uhm, no data received." unless data

    for isbn, {title, author, value} of data.books
     if value
       price = "EUR #{(value / 100).toFixed(2)}"
       if value > 10 then price = price.green
       if value > 100 then price = price.underline.green

       listing = [isbn, title.substring(0, 42), price]
     else
       price = "None".grey
       listing = [isbn.grey, title.substring(0, 42).grey, price]

     table.push listing

    console.log table.toString()

    if data.errors.length > 0
     errors = new Table head: ["Error"]
     data.errors.forEach (err) ->
       errors.push [err]

     console.log errors.toString()

    retrieve.fail (data) ->
      console.log data

  return