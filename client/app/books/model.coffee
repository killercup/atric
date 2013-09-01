App = require '../app'

attr = DS.attr

App.Book = DS.Model.extend
  isbn: attr 'string'
  title: attr 'string'
  author: attr 'string'
  prices: attr 'raw'
  lastprice: attr 'number'
  amazon: attr 'raw'

  reload: ->
    console.log 'reload?'
    return if @get('full')
    console.log 'yup.'
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