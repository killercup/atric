loading = require('common/loading')

notifications = Ember.A []

App = Ember.Application.create
  User: window.User
  loading: loading
  notifications: notifications

App.ApplicationController = Ember.Controller.extend
  notifications: notifications

  notify: (options) ->
    this.get('notifications').pushObject options

module.exports = App