App = require './app'

App.Router.map ->
  @resource 'books', ->
    @resource 'book', path: ':book_id'

App.IndexRoute = Ember.Route.extend
  User: window.User
  redirect: ->
    @transitionTo 'books' if window.User
