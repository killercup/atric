loading = require('common/loading')

notifications = Ember.A []

App = Ember.Application.create
  User: window.User
  loading: loading
  notifications: notifications

App.reopen
  titleChanged: (->
    t = @get('title')
    console.log 'titleChanged'
    if t isnt ''
      document.title = "#{t} / ATRIC"
    else
      document.title = "ATRIC"
  ).observes('title')

App.ApplicationController = Ember.Controller.extend
  notifications: notifications

  notify: (options) ->
    this.get('notifications').pushObject options

module.exports = App