App = require 'app'

App.SettingsRoute = Ember.Route.extend
  model: ->
    window.User

  # setupController: (controller) ->
    # controller.set 'title', 'Settings'

# App.SettingsController = Ember.ObjectController.extend
#   needs: ['application']

module.exports = App.SettingsController