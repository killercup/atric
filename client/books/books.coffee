App = require '../app'
attr = DS.attr

App.BooksRoute = Ember.Route.extend
  model: ->
    App.Book.find()

App.Book = DS.Model.extend
  isbn: attr 'string'
  title: attr 'string'
  author: attr 'string'
  prices: DS.hasMany 'App.BookPrice', embedded: 'load'
  amazon: DS.belongsTo 'App.BookAmazon', embedded: 'load'

  currentPrice: (->
    @get('prices')?.objectAt?(@get('prices')?.get?('length')-1)?.get?('value') or 0
  ).property('prices.@each.value')

App.BookPrice = DS.Model.extend
  value: attr 'number'
  date: attr 'date'
  book: DS.belongsTo 'App.Book'

App.BookAmazon = DS.Model.extend
  url: attr 'string'
  image: attr 'string'
  book: DS.belongsTo 'App.Book'

App.RESTAdapter.map 'App.Book',
  amazon:
    embedded: 'always'
  prices:
    embedded: 'always'

App.BooksController = Ember.ArrayController.extend
  minPrice: 42
  newISBN: ''

  filtered: (->
    minPrice = @get('minPrice')
    @get('model').filter (item) ->
      item.get('currentPrice') >= minPrice
  ).property('minPrice', 'content.@each.prices.@each.value')

  addBook: (isbn) ->
    newBook = @get('store').createRecord App.Book, isbn: isbn

    @get('store').commit()
    @set('newISBN', '')

App.BookController = Ember.ObjectController.extend
  deleteBook: ->
    @get('model').deleteRecord()
    @get('store').commit()
    alert('fuck yeah')

module.export = App.Book