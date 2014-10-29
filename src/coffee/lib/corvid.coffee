#  SHOW STARS FORKS LAST UPDATE LANGUAGE DESCRIPTION

# SORT - stars, forks, updated
# ORDER - asc, dsc

colors = require 'colors'
request = require 'request'
promise = require 'promise'
pkg = require '../package.json'
dataUtil = require './data'
renderUtil = require './render'
resPageLimit = 100

###
#
# Corvid
#
###


# https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000

# TODO: repo or username can go into either search as a keyword term too.
searchCriteria =
  all: `undefined`
  bare: `undefined`
  clone: `undefined`
  sort: `undefined`
  order: `undefined`
  limit: `undefined`
  type: `undefined`
  username: `undefined`
  repos: `undefined`
  location: `undefined`
  language: `undefined`
  followers: `undefined`
  created: `undefined`
  size: `undefined`
  forks: `undefined`
  created: `undefined`
  pushed: `undefined`
  stars: `undefined`

###
  @method processSearchCriteria - process options and generate user criteria
  @params opts - user defined options
###
processSearchCriteria = (opts) ->
  for key of searchCriteria
    if searchCriteria.hasOwnProperty(key) and opts.hasOwnProperty(key)
      searchCriteria[key] = opts[key]
  searchCriteria

###
  @method process - process user options, get data and render it
  @params options - user options
###
exports.process = process = (options) ->
  searchCriteria = processSearchCriteria options
  if searchCriteria.repos or searchCriteria.username
    dataUtil.getResults(searchCriteria).then (data) ->
      renderUtil.renderData data, searchCriteria
  else
    throw new Error 'no username, organisation or repository criteria specified!'
