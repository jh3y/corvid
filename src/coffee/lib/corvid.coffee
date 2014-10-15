# https://api.github.com/users/<USERNAME>
# https://api.github.com/orgs/<ORGANISATION>
# https://api.github.com/users/<USERNAME>/repos?per_page=100
# https://api.github.com/orgs/<ORGANISATION>/repos?per_page=100
#  SHOW STARS FORKS LAST UPDATE LANGUAGE DESCRIPTION

# SORT ORDER AND LANGUAGE CAN BE HANDLED IN REQUEST :)
# SORT UPDATED IS THE ONLY ONE HANDLED BY THE API, OTHERS WILL NEED TO BE FIXED
# UNLESS WE SWITCH TO USING THE SEARCH REPOS API INSTEAD
# https://api.github.com/search/repositories?q=user:jh3y&sort=stars&per_page=50&page=2

# SORT - stars, forks, updated
# ORDER - asc, dsc

colors = require 'colors'
request = require 'request'
promise = require 'promise'
pkg = require '../package.json'
resPageLimit = 100
requestOptions =
  headers:
    'User-Agent': 'request'
requestCallback = `undefined`
errCallback = ( err) ->
  console.log err


###
# GRAB - Our basic HTTP request method for data. Essentially, a request wrapped # in a promise
###
grab = (options) ->
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
grabPaged = (options, pages) ->
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

###
# GETREPODATA - Returns function data as array of objects
###
grabRepoData = (gName, grabAll)->
  return new promise (resolve, reject) ->
    if grabAll
      requestOptions.url = 'https://api.github.com/search/repositories?q=user:' + gName
      requestCallback = (data) ->
        response = JSON.parse data
        pages = Math.ceil(response.total_count / resPageLimit)
        requestOptions.url = requestOptions.url + '&per_page=' + resPageLimit
        grabPaged(requestOptions, pages).then (data) ->
          resolve data
    else
      requestOptions.url = 'https://api.github.com/search/repositories?q=user:' + gName + '&per_page=' + resPageLimit
      requestCallback = (data) ->
        resolve JSON.parse data
    grab(requestOptions).then requestCallback, errCallback

###
# PROCESS - Our entry point function that processes user options.
###
exports.process = process = (options) ->
  if options and ((options.username and typeof options.username is 'string') or (options.organisation and typeof options.organisation is 'string'))
    gName = (if (options.organisation) then options.organisation else options.username)
    # Decide that this means we should pull down repositories for user/organisation.
    # However, we might just want to browse users maybe or find people via location?
    grabRepoData(gName, options.all).then (data)->
      console.log data
  else
    throw new Error 'no username or organisation specified!'
