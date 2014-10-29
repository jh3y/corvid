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



searchCriteria =
  all: `undefined`
  bare: `undefined`
  clone: `undefined`
  sort: `undefined` # stars, forks, updated
  order: `undefined` # asc, desc
  limit: `undefined` #limit to apply to results
  # https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000
  # USERS TERMS
  type: `undefined` # Could be generated from whether options.username or org
  username: `undefined`
  repos: `undefined` # number of repos for user, this will conflict with repos
  location: `undefined` # string of locations, UK
  language: `undefined` # string of language CoffeeScript for example.
  followers: `undefined` # number of followers.
  created: `undefined` # This should be a date but I'm not sure how this goes across.
  # REPO TERMS
  size: `undefined` #kilobytes of a repo
  forks: `undefined` #number of times, repo has been forked
  created: `undefined` #When a repo was created
  pushed: `undefined` #when repo was last pushed? updated?
  # language:
  # repo:
  # username:
  # TODO: repo or username can go into either search as a keyword term too.
  stars: `undefined` # Number of stars for a repo

processSearchCriteria = (opts) ->
  for key of searchCriteria
    if searchCriteria.hasOwnProperty(key) and opts.hasOwnProperty(key)
      searchCriteria[key] = opts[key]
  searchCriteria

###
# PROCESS - Our entry point function that processes user options.
###
exports.process = process = (options) ->
  searchCriteria = processSearchCriteria options
  if searchCriteria.repos or searchCriteria.username
    dataUtil.getResults(searchCriteria).then (data) ->
      renderUtil.renderData data, searchCriteria
  else
    throw new Error 'no username, organisation or repository criteria specified!'
