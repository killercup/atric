App = require '../app'
Store = require '../store'
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

App.BooksRoute = Ember.Route.extend
  model: ->
    App.Book.find()

App.BookRoute = Ember.Route.extend
  # model: (params) ->
  #   App.Book.find(params.book_id)

  serialize: (model) ->
    book_id: model._id


App.BooksController = Ember.ArrayController.extend
  minPrice: 42
  newISBN: ''

  filtered: (->
    minPrice = @get('minPrice')
    @get('model').filter (item) ->
      item.get('currentPrice') >= minPrice
  ).property('minPrice', 'content.@each.prices.@each.value')

  addBook: (isbn) ->
    newBook = App.Book.create isbn: isbn
    newBook.saveRecord()
    .then =>
      @set('newISBN', '')
      console.log window.newBook = newBook
      @transitionToRoute 'book', newBook.get('id') if newBook.get('id')

App.BookController = Ember.ObjectController.extend
  deleteBook: ->
    title = @get('model').get('title')
    @get('model').deleteRecord()
    .then =>
      alert "#{title} deleted."
      @transitionToRoute 'books'
    .then null, ->
      alert "Couldn't delete #{title}"

module.export = App.Book