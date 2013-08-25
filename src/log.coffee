argv = require('optimist').argv

log = console.log
log.verbose = do ->
  if argv.verbose
    return console.log
  else return ->

module.exports = log