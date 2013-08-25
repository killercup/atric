App = require '../app'

Book = require './model'

App.BooksRoute = Ember.Route.extend
  model: ->
    App.Book.find()

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

  refreshBooks: ->
    $.post('/api/refresh')
    .then ->
      window.location.reload()

module.exports = App.BooksController