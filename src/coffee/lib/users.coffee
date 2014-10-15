###
#
# Users
#
###
promise = require 'promise'
dataUtils = require './data'

resPageLimit = 5
requestOptions =
  headers:
    'User-Agent': 'request'
requestCallback = `undefined`
errCallback = ( err) ->
  console.log err


exports.grab = grab = (gName) ->
  return new promise (resolve, reject) ->
    requestOptions.url = 'https://api.github.com/search/users?q=' + gName + '&per_page=' + resPageLimit
    requestCallback = (data) ->
      resolve JSON.parse data
    dataUtil.grab(requestOptions).then requestCallback, errCallback
