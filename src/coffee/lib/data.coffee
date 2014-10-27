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
resPageLimit = 100
requestOptions =
  headers:
    'User-Agent': 'request'
requestCallback = `undefined`
errCallback = ( err) ->
  console.error err

getUrlParameters = (criteria, qString, order, sort) ->
  genQueryString = ->
    result = 'q='
    if criteria.username and typeof criteria.username is 'string'
      result += 'user:' + criteria.username
    if criteria.repos
      if typeof criteria.repos is 'string'
        result += '+repo:' + criteria.repos
      else if typeof criteria.repos isnt 'boolean' and typeof(parseInt criteria.repos, 10) is 'number'
        result += '+repos:' + criteria.repos
    if criteria.location and typeof criteria.location is 'string'
      result += '+location:' + criteria.location
    if criteria.language and typeof criteria.language is 'string'
      result += '+language:' + criteria.language
    if criteria.followers and typeof criteria.followers isnt 'boolean' and typeof parseInt(criteria.followers, 10) is 'number'
      result += '+followers:%3E' + criteria.followers
    if criteria.forks and typeof criteria.repos isnt 'boolean' and typeof parseInt(criteria.forks, 10) is 'number'
      result += '+forks:%3E' + criteria.forks
    if criteria.stars and typeof criteria.stars isnt 'boolean' and typeof parseInt(criteria.stars, 10) is 'number'
      result += '+stars:%3E' + criteria.stars
    # TODO: Add created, size to query string
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

getRequestOptions = (criteria) ->
  urlBase = 'https://api.github.com/search/'
  urlParameters = getUrlParameters criteria, true, true, true
  requestOptions =
    headers:
      'User-Agent': 'request'
  if criteria.all and criteria.username and typeof criteria.username is 'string' and criteria.repos
    requestOptions.url = urlBase + 'repositories?q=user:' + criteria.username + getUrlParameters criteria, false, false, false
  else if criteria.repos
    requestOptions.url = urlBase + 'repositories?' + urlParameters
  else
    requestOptions.url = urlBase + 'users?' + urlParameters
  requestOptions

getRequestCallback = (criteria) ->
  requestCallback = `undefined`
  if criteria.all and criteria.username and typeof criteria.username is 'string' and criteria.repos
    requestCallback = (data) ->
      response = JSON.parse data
      pages = Math.ceil response.total_count / criteria.limit
      console.log pages, 'is the amount of pages for return'
      grabPaged(requestOptions, pages).then (data) ->
        resolve data
  else
    requestCallback = (data) ->
      console.log data
      resolve JSON.parse data
  requestCallback

getErrCallback = ->
  errCallback = (err) ->
    console.error err
  errCallback


processSearch = (criteria) ->
  prom = new promise (resolve, reject) ->
    requestOptions = getRequestOptions criteria
    requestCallback = getRequestCallback criteria
    errCallback = getErrCallback()
    console.log requestOptions.url, 'is where we are going'
    grab(requestOptions).then requestCallback, errCallback
  prom
###
#
# getResults - The entry point to the data module
#
###
exports.getResults = getResults = (criteria)->
  # If repos then repo URL else if user then user URL
  console.log 'grabbing data with ', criteria
  # processSearch criteria
  return new promise (resolve, reject) ->
    requestOptions = getRequestOptions criteria
    # requestCallback = getRequestCallback criteria
    requestCallback = `undefined`
    if criteria.all and criteria.username and typeof criteria.username is 'string' and criteria.repos
      console.log 'THIS IS CALLBACK'
      requestCallback = (data) ->
        response = JSON.parse data
        pages = Math.ceil response.total_count / criteria.limit
        console.log pages, 'is the amount of pages for return'
        grabPaged(requestOptions, pages).then (data) ->
          resolve data
    else
      requestCallback = (data) ->
        resolve JSON.parse data
    errCallback = getErrCallback()
    console.log requestOptions.url, 'is where we are going'
    grab(requestOptions).then requestCallback, errCallback
