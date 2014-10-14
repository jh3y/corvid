# https://api.github.com/users/<USERNAME>
# https://api.github.com/orgs/<ORGANISATION>
# https://api.github.com/users/<USERNAME>/repos?per_page=100
# https://api.github.com/orgs/<ORGANISATION>/repos?per_page=100

colors = require 'colors'
request = require 'request'
promise = require 'promise'
pkg = require '../package.json'
resPageLimit = 50



grab = (options) ->
  return new promise (resolve, reject) ->
    request options, (e, r, b) ->
      if e
        return reject e
      else if r.statusCode isnt 200
        body = JSON.parse b
        return reject(new Error("Unexpected status code: " + r.statusCode + ', ' + body.message))
      resolve b

grabPaged = (options, pages) ->
  repoData = []
  promises = []

  i = 1
  while i < (pages + 1)
    options.url = options.url + '&page=' + i.toString()
    promises.push grab(options)
    i++

  return new promise (resolve, reject) ->
    promise.all(promises).then (data)->
      repoData = `undefined`
      len = 0
      while len < data.length
        if repoData
          repoData = repoData.concat data[len]
        else
          repoData = data[len]
        len++
      resolve repoData

exports.process = process = (options) ->
  if options and options.username and typeof options.username is 'string'
    requestOptions =
      url: 'https://api.github.com/users/' + options.username.toString(),
      headers:
        'User-Agent': 'request'

    grab(requestOptions).then (data)->
      response = JSON.parse data
      pages = Math.ceil(response.public_repos / resPageLimit)
      requestOptions.url = requestOptions.url + '/repos?per_page=' + resPageLimit
      grabPaged(requestOptions, pages).then (data) ->
        console.log 'DATA PULLED WHOOOP'
    , (err) ->
      console.log err

  else if options and options.organisation and typeof options.organisation is 'string'
    console.log 'lets grab an organisation then'
  else
    throw new Error 'no username or organisation specified!'
