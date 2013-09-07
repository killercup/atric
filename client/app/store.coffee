App.RESTAdapter = DS.RESTAdapter.extend
  namespace: 'api'

App.RawTransform = DS.Transform.extend
  deserialize: (serialized) -> serialized
  serialize: (deserialized) -> deserialized

App.Store = DS.Store.extend
  adapter: App.RESTAdapter,
  revision: '1.0-beta2'

module.exports = App.Store