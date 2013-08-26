App = require '../app'

Book = require './model'

App.PriceChartView = require './price-chart'

# App.BookRoute = Ember.Route.extend
#   serialize: (model) ->
#     book_id: model._id

App.BookController = Ember.ObjectController.extend
  deleteBook: ->
    title = @get('model').get('title')
    @get('model').deleteRecord()
    .then =>
      alert "#{title} deleted."
      @transitionToRoute 'books'
    .then null, ->
      alert "Couldn't delete #{title}"

module.exports = App.BookController