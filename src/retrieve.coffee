yaml = require('js-yaml')
Q = require('q')

OperationHelper = require('apac').OperationHelper

CONFIG = require('../_config.yml')

doOp = new OperationHelper
  awsId: CONFIG.amazon.key
  awsSecret: CONFIG.amazon.secret
  assocId: CONFIG.amazon.associate
  endPoint: CONFIG.amazon.endPoint

fetchFromAmazon = (isbn) ->
  deferred = Q.defer()
  doOp.execute 'ItemLookup', {
    'ItemId': isbn
    'IdType': 'ISBN'
    'SearchIndex': 'All'
    'ResponseGroup': 'ItemAttributes,Images'
  }, (err, res) ->
    deferred.reject(new Error(err)) if err

    item = res?.ItemLookupResponse?.Items?[0]?.Item?[0]
    deferred.reject(new Error(Error: "No Item Data")) unless item?

    data = item?.ItemAttributes?[0]
    image = item?.LargeImage?[0]?.URL?[0]

    deferred.resolve
      isbn: isbn
      title: data.Title?[0]
      author: data.Author?[0]
      value: data.TradeInValue?[0]?.FormattedPrice?[0]
      image: image

  return deferred.promise

module.exports = (books) ->
  deferred = Q.defer()
  fetching = books.map fetchFromAmazon

  Q.allSettled(fetching).then (res) ->
    all = {}
    res.forEach (promise) ->
      if promise.state is "fulfilled"
        val = promise.value
        all[val.isbn] = val

    deferred.resolve all

  return deferred.promise

