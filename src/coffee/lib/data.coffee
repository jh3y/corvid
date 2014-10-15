###
#
# Data Utilities for grabbing data simply or paged
#
###
colors = require 'colors'
request = require 'request'
promise = require 'promise'

###
# GRAB - Our basic HTTP request method for data. Essentially, a request wrapped # in a promise
###
exports.grab = grab = (options) ->
  return new promise (resolve, reject) ->
    request options, (e, r, b) ->
      if e
        return reject e
      else if r.statusCode isnt 200
        body = JSON.parse b
        return reject(new Error("Unexpected status code: " + r.statusCode + ', ' + body.message))
      resolve b
###
# GRABPAGED - An function that will group grab promises into one promise for
# grabbing paged data from the API
###
exports.grabPaged = grabPaged = (options, pages) ->
  pagedData = []
  promises = []
  i = 1
  while i < (pages + 1)
    options.url = options.url + '&page=' + i.toString()
    promises.push grab(options)
    i++
  return new promise (resolve, reject) ->
    promise.all(promises).then (data)->
      len = 0
      while len < data.length
        if pagedData
          pagedData = pagedData.concat JSON.parse(data[len]).items
        else
          pagedData = JSON.parse(data[len]).items
        len++
      resolve pagedData
