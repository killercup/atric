App = require '../app'

Book = require './model'

App.BooksRoute = Ember.Route.extend
  model: ->
    @store.find('book')

App.BooksController = Ember.ArrayController.extend
  minPrice: 42
  newISBN: ''
  sortProperties: ['author', 'title']

  filteredContent: (->
    minPrice = @get('minPrice') or 0
    search = RegExp (@get('searchText') or ''), 'gi'

    @get('content').filter (item, index, self) ->
      (item.get('currentPrice') >= minPrice) and \
      (search is '' or search.test(item.get('title')) or search.test(item.get('author')))

  ).property('minPrice', 'searchText', 'content.@each.currentPrice')

  sortedContent: Ember.computed.sort('filteredContent', 'sortProperties')

  priceSum: (->
    @get('filteredContent').reduce ((memo, item) ->
      memo + item.get('currentPrice')
    ), 0
  ).property('filteredContent')

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