App = require '../app'

Book = require './model'

App.PriceChartView = require './price-chart'

App.BookRoute = Ember.Route.extend
  model: (params) ->
    Book.find(params.book_id)

App.BookController = Ember.ObjectController.extend
  actions:
    deleteBook: ->
      title = @get('model').get('title')

      @get('model').one 'didDelete', =>
        alert "#{title} deleted."
        @transitionToRoute 'books'

      @get('model').deleteRecord()
      @get('store').commit()

module.exports = App.BookController