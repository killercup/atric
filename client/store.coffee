# serializer = DS.RESTSerializer.extend
#   primaryKey: (type) -> '_id'

App.RESTAdapter = RL.RESTAdapter.create
  namespace: 'api'
  # serializer: serializer
  # serializeId: (id) -> id.toString()

App.Client = RL.Client.create
  adapter: App.RESTAdapter

module.exports = App.Client