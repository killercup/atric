App = require '../app'

Book = require './model'

App.BooksRoute = Ember.Route.extend
  model: ->
    @store.find('book')

App.BooksController = Ember.ArrayController.extend
  minPrice: 42
  newISBN: ''

  filtered: (->
    minPrice = @get('minPrice') or 0
    search = RegExp (@get('searchText') or ''), 'gi'

    @get('model').filter (item) ->
      (item.get('currentPrice') >= minPrice) and \
      (search.test(item.get('title')) or search.test(item.get('author')))

  ).property('minPrice', 'searchText', 'model.@each')

  priceSum: (->
    @get('filtered').reduce ((memo, item) ->
      memo + item.get('currentPrice')
    ), 0
  ).property('filtered')

  newISBNInvalid: (->
    return not /^((\d{10})|(\d{13}))$/.test(@get('newISBN'))
  ).property('newISBN')

  actions:
    addBook: (isbn='') ->
      return if @get('newISBNInvalid')
      newBook = @store.createRecord 'book', isbn: isbn
      newBook.save().then =>
        @set('newISBN', '')
        @transitionToRoute 'book', newBook
      .then null, (err) ->
        console.error err
        alert 'doh!'

module.exports = App.BooksController