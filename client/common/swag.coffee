Ember.Handlebars.registerBoundHelper 'truncate', (str='', params={}) ->
  options = params.hash || {}
  length = options.length || 90
  omission = options.omission || '...'
  length = parseInt(length, 10)
  if str.length > length
    str.substring(0, length - omission.length) + omission
  else str

Ember.Handlebars.registerBoundHelper 'money', (value=0, params={}) ->
  options = params.hash || {}
  currency = options.currency || "€"
  prefix = options.prefix || false

  value = parseInt(value)

  formatted_value = if value > 0 then (value / 100).toFixed(2) else 0

  if prefix
    "#{currency} #{formatted_value}"
  else
    "#{formatted_value}#{currency}"

