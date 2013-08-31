App = require '../app'

Book = require './model'

App.PriceChartView = require './price-chart'

App.BookRoute = Ember.Route.extend
  model: (params) ->
    Book.find(params.book_id)

  setupController: (controller, model) ->
    controller.set("model", model)

    unless model.get('full') is true
      model.reload().then ->
        model.set('full', true)
    return

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