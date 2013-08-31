LoadingIndicator = Ember.Object.extend
  count: 0
  busy: (->
    @get('count') > 0
  ).property('count')

loading = LoadingIndicator.create()

$(document).on 'ajaxStart', ->
  loading.incrementProperty 'count', 1
  return

$(document).on 'ajaxStop', ->
  loading.decrementProperty 'count', 1
  return

App = Ember.Application.create
  User: window.User
  loading: loading

module.exports = App