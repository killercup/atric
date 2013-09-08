module.exports.truncate = (str='', params={}) ->
  options = params.hash || {}
  length = options.length || 90
  omission = options.omission || '...'
  length = parseInt(length, 10)
  if str.length > length
    str.substring(0, length - omission.length) + omission
  else str

module.exports.money = (value=0, params={}) ->
  options = params.hash || {}
  currency = options.currency || "€"
  prefix = options.prefix || false

  value = parseInt(value)

  formatted_value = if value > 0 then (value / 100).toFixed(2) else 0

  if prefix
    "#{currency} #{formatted_value}"
  else
    "#{formatted_value}#{currency}"

module.exports.date = (date, params={}) ->
  throw Error('date helper requires d3.') unless d3?.time?.format?

  options = params.hash || {}
  format = options.format || '%d %b %y %H:%M:%S'

  date = new Date(date)
  format_date = d3.time.format(format)

  return format_date(date)

Ember.Handlebars.registerBoundHelper 'truncate', module.exports.truncate
Ember.Handlebars.registerBoundHelper 'money', module.exports.money
Ember.Handlebars.registerBoundHelper 'date', module.exports.date
