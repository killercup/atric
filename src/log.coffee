argv = require('optimist').argv

log = console.log

log.error = console.error

log.verbose = do ->
  if argv.verbose
    return console.log
  else return ->

module.exports = log