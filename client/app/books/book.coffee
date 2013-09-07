App = require '../app'

Book = require './model'

App.PriceChartView = require './price-chart'

App.BookRoute = Ember.Route.extend
  model: (params) ->
    @store.find('book', params.book_id)

  setupController: (controller, model) ->
    controller.set("model", model)

    unless model.get('full') is true
      model.reload().then ->
        # We now have all the information.
        # Setting `full` to `true` to prevent loading it again.
        model.set('full', true)
    return

App.BookController = Ember.ObjectController.extend
  actions:
    deleteBook: ->
      book = @get('model')
      title = book.get('title')

      book.deleteRecord()
      book.save()
      .then (data) =>
        # TODO implement cool alerts
        alert "#{title} deleted."
        @transitionToRoute 'books'
      .then null, (err) ->
        console.error err
        alert 'doh!'

module.exports = App.BookController