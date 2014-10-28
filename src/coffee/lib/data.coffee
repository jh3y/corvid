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


###
# Variables for data requests
###

getUrlParameters = (criteria, qString, order, sort) ->
  resPageLimit = 100

  genQueryString = ->
    regex = new RegExp ' ', 'g'
    queryObj = {}
    if criteria.username and typeof criteria.username is 'string'
      # result += 'user:' + criteria.username
      queryObj.user = criteria.username
    if criteria.repos and typeof criteria.repos isnt 'boolean' and !isNaN parseInt(criteria.repos, 10)
        # result += '+repos:%3E' + criteria.repos
        console.log typeof(parseInt(criteria.repos, 10))
        queryObj.repos = '%3E' + criteria.repos
    if criteria.location and typeof criteria.location is 'string'
      # result += '+location:' + criteria.location.replace regex, '%2B'
      queryObj.location = criteria.location.replace regex, '%2B'
    if criteria.language and typeof criteria.language is 'string'
      # result += '+language:' + criteria.language
      queryObj.language = criteria.language
    if criteria.followers and typeof criteria.followers isnt 'boolean' and typeof parseInt(criteria.followers, 10) is 'number'
      # result += '+followers:%3E' + criteria.followers
      queryObj.followers = '%3E' + criteria.followers
    if criteria.forks and typeof criteria.repos isnt 'boolean' and typeof parseInt(criteria.forks, 10) is 'number'
      # result += '+forks:%3E' + criteria.forks
      queryObj.forks = '%3E' + criteria.forks
    if criteria.stars and typeof criteria.stars isnt 'boolean' and typeof parseInt(criteria.stars, 10) is 'number'
      # result += '+stars:%3E' + criteria.stars
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
  if qString #q=user:jh3y+repo:whirl+language:CSS
    parameterString += genQueryString()
  #&sort=[stars,forked,updated]
  if sort and criteria.sort and typeof criteria.sort is 'string'
    parameterString += '&sort=' + criteria.sort
  #&order=[asc, desc]
  if order and criteria.order and typeof criteria.order is 'string'
    parameterString += '&order=' + criteria.order
  #&per_page='resPageLimit'
  if criteria.limit and typeof criteria.limit isnt 'boolean' and typeof parseInt(criteria.limit, 10) is 'number'
    parameterString += '&per_page=' + criteria.limit
  else
    criteria.limit = resPageLimit
    parameterString += '&per_page=' + resPageLimit
  parameterString


hasCriteria = (criteria) ->
  hasCriteria = false
  if criteria.location or criteria.language or criteria.followers or criteria.forks or criteria.stars
    hasCriteria = true
  else
    hasCriteria = false
  hasCriteria

getRequestOptions = (criteria) ->
  urlBase = 'https://api.github.com/'
  urlParameters = getUrlParameters criteria, true, true, true
  repoName = (if (typeof criteria.repos is 'string') then criteria.repos + '&' else '')
  requestOptions =
    headers:
      'User-Agent': 'request'
  if criteria.all and criteria.username and typeof criteria.username is 'string' and criteria.repos
    requestOptions.url = urlBase + 'search/repositories?q=user:' + criteria.username + getUrlParameters criteria, false, false, false
  else if criteria.repos and isNaN parseInt(criteria.repos, 10)
    requestOptions.url = urlBase + 'search/repositories?' + urlParameters
  else if criteria.username and hasCriteria criteria
    requestOptions.url = urlBase + 'search/users?' + criteria.username + urlParameters
  else if criteria.username
    requestOptions.url = urlBase + 'users/' + criteria.username
  requestOptions

getErrCallback = ->
  errCallback = (err) ->
    console.error err
  errCallback

###
#
# getResults - The entry point to the data module
#
###
exports.getResults = getResults = (criteria)->
  console.log 'grabbing data with ', criteria
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
    console.log requestOptions.url, 'is where we are going'
    grab(requestOptions).then requestCallback, errCallback
