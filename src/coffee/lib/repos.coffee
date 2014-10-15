###
# GETREPODATA - Returns function data as array of objects
###
colors = require 'colors'
request = require 'request'
promise = require 'promise'
dataUtil = require './data'

resPageLimit = 100
requestOptions =
  headers:
    'User-Agent': 'request'
requestCallback = `undefined`
errCallback = ( err) ->
  console.log err


exports.grab = grab = (gName, grabAll)->
  return new promise (resolve, reject) ->
    if grabAll
      requestOptions.url = 'https://api.github.com/search/repositories?q=user:' + gName
      requestCallback = (data) ->
        response = JSON.parse data
        pages = Math.ceil(response.total_count / resPageLimit)
        requestOptions.url = requestOptions.url + '&per_page=' + resPageLimit
        dataUtil.grabPaged(requestOptions, pages).then (data) ->
          resolve data
    else
      requestOptions.url = 'https://api.github.com/search/repositories?q=user:' + gName + '&per_page=' + resPageLimit
      requestCallback = (data) ->
        resolve JSON.parse data
    dataUtil.grab(requestOptions).then requestCallback, errCallback
