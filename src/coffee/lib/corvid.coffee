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
dataUtil = require './data'
repos = require './repos'
resPageLimit = 100

###
# PROCESS - Our entry point function that processes user options.
###
exports.process = process = (options) ->
  if options and ((options.username and typeof options.username is 'string') or (options.organisation and typeof options.organisation is 'string'))
    gName = (if (options.organisation) then options.organisation else options.username)
    # Decide that this means we should pull down repositories for user/organisation.
    # However, we might just want to browse users maybe or find people via location?
    if options.repositories or options.clone
      ###
      # REPOS FLAG SET SO GRAB REPOS FOR GIVEN USERNAME/ORG
      ###
      console.log 'We are cloning or browsing repos'
      # repos.grab(gName, options.all).then (data) ->
      #   console.log data, 'REPOS'
    else
      ###
      # NO REPO FLAG SO GRAB USER/ORGANISATION - FINDING JUST DETAILS FOR USER OR ORGANISATION
      ###
      console.log 'Just grab the user'
      # users.grab(gName).then (data) ->
      #   console.log data, 'USER'


  else
    throw new Error 'no username or organisation specified!'
