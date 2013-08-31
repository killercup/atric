App = require './app'

App.Router.map ->
  @resource 'books', ->
    @resource 'book', path: ':book_id'

App.IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo 'books' if App.User
