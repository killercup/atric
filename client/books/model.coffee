App = require '../app'

attr = DS.attr

App.Book = DS.Model.extend
  # id: attr 'string'
  isbn: attr 'string'
  title: attr 'string'
  author: attr 'string'
  prices: DS.hasMany 'App.BookPrice', embedded: 'load'
  amazon: DS.belongsTo 'App.BookAmazon', embedded: 'load'

  currentPrice: (->
    @get('prices')?.objectAt?(@get('prices')?.get?('length')-1)?.get?('value') or 0
  ).property('prices.@each.value')

  trend: (->
    # latest price -> length-1
    now = @get('currentPrice')
    # second to last price -> length-2
    earlier = @get('prices')?.objectAt?(@get('prices')?.get?('length')-2)?.get?('value') or 0

    if now > earlier then 'up'
    else if now == earlier then 'unchanged'
    else 'down'
  ).property('currentPrice')

  trend2glyph: (->
    trend = @get('trend')
    if trend is 'up' then "glyphicon-circle-arrow-up"
    if trend is 'down' then "glyphicon-circle-arrow-down"
    else "glyphicon-circle-arrow-right"
  ).property('trend')

App.BookPrice = DS.Model.extend
  value: attr 'number'
  date: attr 'date'
  book: DS.belongsTo 'App.Book'

App.BookAmazon = DS.Model.extend
  url: attr 'string'
  image: attr 'string'
  book: DS.belongsTo 'App.Book'

App.RESTAdapter.map 'App.Book',
  primaryKey: '_id'
  amazon:
    embedded: 'always'
  prices:
    embedded: 'always'

module.exports = App.Book