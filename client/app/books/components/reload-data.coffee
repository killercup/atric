App.ReloadDataComponent = Ember.Component.extend
  tagName: 'li'

  actions:
    refreshBooks: ->
      $.post('/api/refresh')
      .then ->
        window.location.reload()