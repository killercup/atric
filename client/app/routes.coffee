App = require './app'

App.Router.map ->
  @route 'index', path: '/'
  @route 'catchAll', path: '*:'
  @route 'settings'
  @resource 'books', ->
    @resource 'book', path: ':book_id'

App.CatchAllRoute = Ember.Route.extend
  templateName: 'missing'

App.IndexRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'title', 'ATRIC'

  redirect: ->
    @transitionTo 'books' if App.User

App.LoadingRoute = Ember.Route.extend()
