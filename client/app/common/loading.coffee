LoadingIndicator = Ember.Object.extend
  count: 0

  busy: (->
    @get('count') > 0
  ).property('count')

  loading: (->
    if @get('busy') then 'loading' else ''
  ).property('busy')

loading = LoadingIndicator.create()

$(document).on 'ajaxStart', ->
  loading.incrementProperty 'count', 1
  return

$(document).on 'ajaxStop', ->
  loading.decrementProperty 'count', 1
  return

module.exports = loading