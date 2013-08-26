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
  ).property('minPrice', 'model.@each')

  addBook: (isbn) ->
    newBook = App.Book.createRecord isbn: isbn
    newBook.one 'didCreate', =>
      @set('newISBN', '')
      console.log window.newBook = newBook
      @transitionToRoute 'book', newBook
      console.log 'no id for', newBook unless newBook.get('id')

    @get('store').commit()

  refreshBooks: ->
    $.post('/api/refresh')
    .then ->
      window.location.reload()

module.exports = App.BooksController