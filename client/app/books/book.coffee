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
  needs: ['application']

  actions:
    deleteBook: ->
      book = @get('model')
      title = book.get('title')

      book.deleteRecord()
      book.save()
      .then (data) =>
        @get("controllers.application").notify
          title: "#{title} deleted.",
          message: "Eternal rest, grant unto it, and let perpetual light shine upon it.",
          type: "alert-success",
          persists: true

        @transitionToRoute 'books'
      .then null, (err) ->
        console.error err
        alert 'doh!'

module.exports = App.BookController