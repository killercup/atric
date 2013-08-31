serializer = DS.RESTSerializer.extend
  primaryKey: (type) -> '_id'

DS.RESTAdapter.registerTransform 'raw',
  deserialize: (serialized) -> serialized
  serialize: (deserialized) -> deserialized

App.RESTAdapter = DS.RESTAdapter.extend
  namespace: 'api'
  serializer: serializer
  serializeId: (id) -> id.toString()

App.Store = DS.Store.extend
  adapter: App.RESTAdapter,
  revision: 13

module.exports = App.Store