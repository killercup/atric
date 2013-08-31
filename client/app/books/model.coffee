App = require '../app'

attr = DS.attr

App.Book = DS.Model.extend
  isbn: attr 'string'
  title: attr 'string'
  author: attr 'string'
  prices: attr 'raw'
  amazon: attr 'raw'

  currentPrice: (->
    ps = @get('prices')
    ps?[ps.length - 1]?.value or 0
  ).property('prices')

  # second to last price
  penultimatePrice: (->
    ps = @get('prices')
    ps?[ps.length - 2]?.value or 0
  ).property('prices')

  trend: (->
    now = @get('currentPrice')
    earlier = @get('penultimatePrice')

    if now > earlier then 'up'
    else if now == earlier then 'unchanged'
    else 'down'
  ).property('currentPrice')

  trend2glyph: (->
    trend = @get('trend')
    if trend is 'up' then "glyphicon-circle-arrow-up"
    else if trend is 'down' then "glyphicon-circle-arrow-down"
    else "glyphicon-circle-arrow-right"
  ).property('trend')

module.exports = App.Book