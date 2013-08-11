yaml = require('js-yaml')
Q = require('q')

OperationHelper = require('apac').OperationHelper

CONFIG = require('./_config.yml')

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
    'ResponseGroup': 'ItemAttributes'
  }, (err, res) ->
    deferred.reject(new Error(err)) if err

    item = res?.ItemLookupResponse?.Items?[0]?.Item?[0]?.ItemAttributes?[0]
    deferred.reject(new Error(Error: No Item Data)) unless item?

    deferred.resolve
      isbn: isbn
      title: item.Title?[0]
      author: item.Author?[0]
      value: item.TradeInValue?[0]?.FormattedPrice?[0]

  return deferred.promise

books = require './books.yml'

fetching = books.books.map fetchFromAmazon

Q.allSettled(fetching).then (res) ->
  all = {}
  res.forEach (promise) ->
    if promise.state is "fulfilled"
      val = promise.value
      all[val.isbn] = val

  console.log JSON.stringify(all, null, 2)

