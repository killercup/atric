yaml = require('js-yaml')
Q = require('q')

OperationHelper = require('apac').OperationHelper

log = require('./log')

CONFIG = require('../_config.yml')

doOp = new OperationHelper
  awsId: CONFIG.amazon.key
  awsSecret: CONFIG.amazon.secret
  assocId: CONFIG.amazon.associate
  endPoint: CONFIG.amazon.endPoint

fetchFromAmazon = (isbn) ->
  deferred = Q.defer()
  # log.verbose "getting #{isbn}"
  doOp.execute 'ItemLookup', {
    'ItemId': isbn
    'IdType': 'ISBN'
    'SearchIndex': 'All'
    'ResponseGroup': 'ItemAttributes,Images'
  }, (err, res) ->
    if err
      # log.verbose "error #{isbn}"
      return deferred.reject(err)

    item = res?.ItemLookupResponse?.Items?[0]?.Item?[0]
    return deferred.reject("No Item Data for #{isbn}") unless item?

    data = item?.ItemAttributes?[0]
    return deferred.reject("No Item Data for #{isbn}") unless data?

    image = item?.LargeImage?[0]?.URL?[0]

    # log.verbose "got #{isbn}"
    deferred.resolve
      isbn: isbn.toString?()
      title: data.Title?[0]
      author: data.Author?[0]
      value: data.TradeInValue?[0]?.Amount?[0]
      image: image
      url: item.DetailPageURL?[0]

  return deferred.promise

getAll = (books) ->
  deferred = Q.defer()
  fetching = books.map fetchFromAmazon

  Q.allSettled(fetching).then (res) ->
    all = errors: [], books: {}
    res.forEach (promise) ->
      if promise.state is "fulfilled"
        val = promise.value
        all.books[val.isbn] = val
      else
        all.errors.push promise.reason

    deferred.resolve all

  return deferred.promise

module.exports = getAll
module.exports.fetchFromAmazon = fetchFromAmazon
