colors = require('colors')
Table = require('cli-table')

module.exports = (retrieve, {skipBelow, nonEmpty}) ->
  table = new Table
    head: ["ISBN", "Title", "Value"]

  retrieve.then (data) ->
    return console.log "Uhm, no data received." unless data

    for isbn, {title, value} of data.books
      if value
        price = "EUR #{(value / 100).toFixed(2)}"
        if value > 10 then price = price.green
        if value > 100 then price = price.underline.green

        if !skipBelow or value >= parseInt(skipBelow, 10)
          table.push [isbn, title.substring(0, 42), price]
      else unless nonEmpty or skipBelow
        price = "None".grey
        table.push [isbn.grey, title.substring(0, 42).grey, price]

    console.log table.toString()

    if data.errors.length > 0
      errors = new Table head: ["Error"]
      data.errors.forEach (err) ->
        errors.push [err]

    console.log errors.toString()

    retrieve.fail (data) ->
      console.log data

  return