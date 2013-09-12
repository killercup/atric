App = require 'app'

App.SettingsRoute = Ember.Route.extend
  model: ->
    window.User

  activate: ->
    key.setScope 'settings'

  # setupController: (controller) ->
    # controller.set 'title', 'Settings'

App.SettingsController = Ember.ObjectController.extend
  needs: ['application']

  actions:
    'delete-user': () ->
      actuallyTriggerDelete = =>
        $.ajax
          url: '/api/users/me'
          method: 'DELETE'
        .then ->
          window.alert "Your account has been deleted. Goodbye!"
          window.location.reload()
        .then null, ->
          window.alert "There was a problem. Sorry."

      sure = window.confirm "Are you sure you want to delete your account from ATRIC?"
      if not sure
        @get("controllers.application").notify
          title: "That was close!"
          message: "I'm glad you decided to stay."
          type: "alert-success"
      else
        actuallyTriggerDelete()

module.exports = App.SettingsController