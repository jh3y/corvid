program = require 'commander'
colors = require 'colors'
pkg = require '../package.json'
corvid = require './corvid'
interactiveUtils = require './interactive'
###
#
# Main entry point into corvid
#
###

#TODO: Support created, pushed/updated
program
  .version(pkg.version)
  .option '-a, --all', 'use if expecting more than 100 results'
  .option '-u, --username [username]', 'git username'
  .option '-r, --repos [count]', 'defines flag for grabbing repos, repo name or number of repos for user'
  .option '-i, --interactive', 'enables interactive search criteria generation'
  .option '-b, --bare', 'return less information in results'
  .option '-c, --clone', 'provide interactive cloning of user/org repos'
  .option '--sort [criteria]', 'how to sort results [forks, stars, updated]'
  .option '--order [order]', 'how to order results [asc, desc]'
  .option '-l, --limit [limit]', 'limit the number of results [< 100]'
  .option '--location [location]', 'location for a user'
  .option '--language [language]', 'language for user or repo'
  .option '--followers [followers]', 'minimum amount of followers for a repo or user'
  .option '-f, --forks [forks]', 'minimum amount of forks for repo'
  .option '-s, --stars [stars]', 'minimum amount of stars for a repo'


program.on '--help', ->
  console.log '  Examples:'
  console.log '    $ ' + pkg.name + ' -u jh3y'
  console.log '    $ ' + pkg.name + ' -u twbs -r --limit 5'
  console.log '    $ ' + pkg.name + ' -u Tom --followers 1000'
  console.log '    $ ' + pkg.name + ' -u --language CSS --location "New York"'
  console.log '    $ ' + pkg.name + ' -r --language CoffeeScript --stars 1000 --order updated'
  return

program.parse process.argv

startCorvid = (options) ->
  try
    corvid.process
      all: options.all
      username: options.username
      repos: options.repos
      interactive: options.interactive
      organisation: options.organisation
      clone: options.clone
      bare: options.bare
      sort: options.sort
      order: options.order
      limit: options.limit
      location: options.location
      language: options.language
      followers: options.followers
      forks: options.forks
      stars: options.stars
  catch err
    console.log '[', 'corvid'.white, ']', err.toString().red

if process.argv.length is 2
  program.help()
else
  if program.interactive
    interactiveUtils.getCriteria().then (data) ->
      startCorvid data
  else
    startCorvid program
