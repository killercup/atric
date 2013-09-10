App = require '../app'

Book = require './model'

App.BooksRoute = Ember.Route.extend
  model: ->
    @store.find('book')

  activate: () ->
    @controllerFor('books').send('pageToggle', 'list')

    key 'j', 'books', (e) =>
      $('.list-books a.active').first().nextAll('a').first().click()
      return
    key 'k', 'books', (e) =>
      $('.list-books a.active').first().prevAll('a').first().click()
      return

    key.setScope 'books'

    return

  # Overriding this method completely screws with the routing for some reason.
  # If I activate this, the controller will not exit and new routes just start
  # appearing below in the same outlet.
  # deactivate: ->
  #   key.unbind 'j', 'books'
  #   key.unbind 'k', 'books'
  #   return

App.BooksController = Ember.ArrayController.extend
  needs: ['application']

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

  pageSection: 'list'

  actions:
    pageToggle: (view) ->
      $('html, body').animate {scrollTop: 0}, 300, =>
        return @set('pageSection', view) if view?

        if @get('pageSection') is 'list'
          @set('pageSection', 'detail')
        else
          @set('pageSection', 'list')

    addBook: (isbn='') ->
      return if @get('newISBNInvalid')
      newBook = @store.createRecord 'book', isbn: isbn
      newBook.save().then =>
        @set('newISBN', '')
        @transitionToRoute 'book', newBook
      .then null, (err) =>
        console.error err
        @get("controllers.application").notify
          title: "Couldn't add your new book :("
          type: "alert-danger"

module.exports = App.BooksController