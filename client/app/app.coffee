loading = require('common/loading')

App = Ember.Application.create
  User: window.User
  loading: loading

module.exports = App