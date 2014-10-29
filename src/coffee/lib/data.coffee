colors = require 'colors'
request = require 'request'
promise = require 'promise'
###
#
# Data Utilities
#
###

###
  @method grab - used for making a data request
  @params options - the request options including url and headers
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
  @method grabPaged - a paged version of grab that utilises grab to pull pages
  @params options - the request options including url and headers
  @params pages - the number of pages of data to be requested
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


###
  @method getUrlParameters - generate dynamic url for request options
  @params criteria - user set options
  @params qString - whether to build query string
  @params order - whether to append ordering query to query string
  @params sort - whether to append sorting query to query string
###
getUrlParameters = (criteria, qString, order, sort) ->
  resPageLimit = 100
  genQueryString = ->
    regex = new RegExp ' ', 'g'
    queryObj = {}
    if criteria.username and typeof criteria.username is 'string'
      queryObj.user = criteria.username
    if criteria.repos and typeof criteria.repos isnt 'boolean' and !isNaN parseInt(criteria.repos, 10)
        console.log typeof(parseInt(criteria.repos, 10))
        queryObj.repos = '%3E' + criteria.repos
    if criteria.location and typeof criteria.location is 'string'
      queryObj.location = criteria.location.replace regex, '%2B'
    if criteria.language and typeof criteria.language is 'string'
      queryObj.language = criteria.language
    if criteria.followers and typeof criteria.followers isnt 'boolean' and typeof parseInt(criteria.followers, 10) is 'number'
      queryObj.followers = '%3E' + criteria.followers
    if criteria.forks and typeof criteria.repos isnt 'boolean' and typeof parseInt(criteria.forks, 10) is 'number'
      queryObj.forks = '%3E' + criteria.forks
    if criteria.stars and typeof criteria.stars isnt 'boolean' and typeof parseInt(criteria.stars, 10) is 'number'
      queryObj.stars = '%3E' + criteria.stars
    # TODO: Add created, size to query string
    result = '&q='
    if typeof criteria.repos is 'string' and isNaN parseInt(criteria.repos, 10)
      result = '&q=' + criteria.repos
    for key of queryObj
      if result is '&q='
        result += key + ':' + queryObj[key]
      else
        result += '+' + key + ':' + queryObj[key]
    result
  parameterString = ''
  if qString
    parameterString += genQueryString()
  if sort and criteria.sort and typeof criteria.sort is 'string'
    parameterString += '&sort=' + criteria.sort
  if order and criteria.order and typeof criteria.order is 'string'
    parameterString += '&order=' + criteria.order
  if criteria.limit and typeof criteria.limit isnt 'boolean' and typeof parseInt(criteria.limit, 10) is 'number'
    parameterString += '&per_page=' + criteria.limit
  else
    criteria.limit = resPageLimit
    parameterString += '&per_page=' + resPageLimit
  parameterString

###
  @method hasCriteria - returns whether criteria related to query string
  @params criteria - the user set criteria
###
hasCriteria = (criteria) ->
  has = false
  if criteria.location or criteria.language or criteria.followers or criteria.forks or criteria.stars
    has = true
  else
    has = false
  has


###
  @method getRequestOptions - returns request options object for use with grab
  @params criteria - the user set criteria
###
exports.getRequestOptions = getRequestOptions = (criteria) ->
  urlBase = 'https://api.github.com/'
  urlParameters = getUrlParameters criteria, true, true, true
  repoName = (if (typeof criteria.repos is 'string') then criteria.repos + '&' else '')
  requestOptions =
    headers:
      'User-Agent': 'request'
  complex = hasCriteria criteria
  if criteria.all and criteria.username and typeof criteria.username is 'string' and criteria.repos
    requestOptions.url = urlBase + 'search/repositories?q=user:' + criteria.username + getUrlParameters criteria, false, false, false
  else if criteria.repos and isNaN parseInt(criteria.repos, 10) and typeof criteria.repos is 'boolean'
    requestOptions.url = urlBase + 'search/repositories?' + urlParameters
  else if criteria.repos and isNaN parseInt(criteria.repos, 10) and typeof criteria.repos is 'string'
    requestOptions.url = urlBase + 'search/repositories?' + criteria.repos + urlParameters
  else if criteria.username and (typeof criteria.username is 'boolean') and complex
    requestOptions.url = urlBase + 'search/users?' + urlParameters
  else if complex and criteria.username and (typeof criteria.username is 'string')
    #NOTE: You have to swap out 'user:' otherwise the github API won't process
    #TODO: Look at configuring this with with getUrlParameters function
    requestOptions.url = urlBase + 'search/users?' + urlParameters.replace 'user:', ''
  else if criteria.username and (typeof criteria.username is 'string') and !complex
    requestOptions.url = urlBase + 'users/' + criteria.username
  requestOptions


###
  @method getErrCallback - returns error callback for grab
###
getErrCallback = ->
  errCallback = (err) ->
    console.error err
  errCallback

###
  @method getResults - process criteria, make request and return data
  @params criteria - user set criteria
###
exports.getResults = getResults = (criteria)->
  return new promise (resolve, reject) ->
    requestOptions = getRequestOptions criteria
    reposRequest = (if (requestOptions.url.indexOf('repos') isnt -1) then true else false)
    requestCallback = `undefined`
    if criteria.all and criteria.username and typeof criteria.username is 'string' and criteria.repos
      requestCallback = (data) ->
        response = JSON.parse data
        pages = Math.ceil response.total_count / criteria.limit
        grabPaged(requestOptions, pages).then (data) ->
          resolve
            data: data
            renderAsRepos: reposRequest
    else
      requestCallback = (data) ->
        resolve
          data: JSON.parse data
          renderAsRepos: reposRequest
    errCallback = getErrCallback()
    grab(requestOptions).then requestCallback, errCallback
