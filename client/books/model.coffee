App = require '../app'

attr = RL.attr

App.Book = RL.Model.extend
  id: attr 'string'
  isbn: attr 'string'
  title: attr 'string'
  author: attr 'string'
  prices: RL.hasMany 'App.BookPrice', embedded: 'load'
  amazon: RL.belongsTo 'App.BookAmazon', embedded: 'load'

  currentPrice: (->
    @get('prices')?.objectAt?(@get('prices')?.get?('length')-1)?.get?('value') or 0
  ).property('prices.@each.value')

App.BookPrice = RL.Model.extend
  value: attr 'number'
  date: attr 'date'
  book: RL.belongsTo 'App.Book'

App.BookAmazon = RL.Model.extend
  url: attr 'string'
  image: attr 'string'
  book: RL.belongsTo 'App.Book'

App.RESTAdapter.map 'App.Book',
  primaryKey: '_id'
  amazon:
    embedded: 'always'
  prices:
    embedded: 'always'

module.exports = App.Book