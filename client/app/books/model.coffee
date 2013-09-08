App = require '../app'

attr = DS.attr

App.BookSerializer = DS.RESTSerializer.extend
  normalize: (type, hash, property) ->
    hash.id = hash._id
    delete hash._id
    @_super(type, hash, property)

App.Book = DS.Model.extend
  isbn: attr 'string'
  title: attr 'string'
  author: attr 'string'
  prices: attr 'raw'
  lastprice: attr 'number'
  amazon: attr 'raw'

  reload: ->
    return if @get('full')
    @_super()

  currentPrice: (->
    ps = @get('prices')
    ps?[ps.length - 1]?.value or @get('lastprice') or 0
  ).property('prices')

  # second to last price
  penultimatePrice: (->
    ps = @get('prices')
    ps?[ps.length - 2]?.value
  ).property('prices')

  trend: (->
    now = @get('currentPrice')
    earlier = @get('penultimatePrice')

    return '' unless earlier

    if now > earlier then 'up'
    else if now == earlier then 'unchanged'
    else 'down'
  ).property('currentPrice')

module.exports = App.Book