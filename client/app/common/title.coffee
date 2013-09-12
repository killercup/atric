App = require 'app'

original = document.title

App.reopen
  titleChanged: (->
    page = @get('title')
    if page then title = "#{page} / "
    document.title = "#{title or ''}#{original}"
  ).observes('title')

module.exports = App
