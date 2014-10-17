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



searchCriteria =
  sort: `undefined` # stars, forks, updated
  order: `undefined` # asc, desc
  limit: `undefined` #limit to apply to results
  # https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000
  # USERS TERMS
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
  # TODO: repo or username can go into either search as a keyword term too.
  stars: `undefined` # Number of stars for a repo


processSearchCriteria = (opts) ->
  for key of searchCriteria
    if searchCriteria.hasOwnProperty key and opts[key]
      searchCriteria[key] = opts[key]

###
# PROCESS - Our entry point function that processes user options.
###
exports.process = process = (options) ->
  # Need to process the searchCriteria first.


  #If the repo flag is set this should take precedence.
  # Only have to look at some flags from search criteria
  ###
    corvid -c [repoName] user/size/forks/created/stars/pushed
    corvid -r [repoName] user/size/forks/created/stars/pushed
  ###
  if options and ((options.repos and typeof options.repos is 'string') or (options.clone and typeof options.clone is 'string'))
    if options.clone
      console.log 'Cloning repos of certain name'
    else
      console.log 'Browsing repos'
  ###
    Else, we are dealing with users.

    corvid -u [username] repos/location/language/followers/created
    We should look at whether the username is string or not if it's string and repos is not string then we are looking at pulling repos for user but this is handled by the above.
    SHOULD NOT MATTER
    If type string just getting a user, if empty getting whoever we find.

  ###
  else if options and ((options.username and typeof options.username is 'string') or (options.organisation and typeof options.organisation is 'string'))
    gName = (if (options.organisation) then options.organisation else options.username)
    # Decide that this means we should pull down repositories for user/organisation.
    # However, we might just want to browse users maybe or find people via location?
    if options.repos or options.clone
      ###
      # REPOS FLAG SET SO GRAB REPOS FOR GIVEN USERNAME/ORG
      ###
      console.log 'We are cloning or browsing repos for a user'
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
    throw new Error 'no username, organisation or repository criteria specified!'
