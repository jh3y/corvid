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
  .option '-a, --all', 'use if more than 100 repos'
  .option '-u, --username [username]', 'git username to be browsed'
  .option '-r, --repos [count]', 'flag for grabbing repos and also defining number of repos for user'
  .option '-i, --interactive', 'enables interactive search'
  .option '-b, --bare', 'return less information'
  .option '-o, --organisation [organisation]', 'git organisation to be browsed'
  .option '-c, --clone', 'provide interactive cloning of user/org repos'
  .option '--sort [criteria]', 'how to sort results [forks, stars, updated]'
  .option '--order [order]', 'how to order results [asc, desc]'
  .option '-l, --limit [limit]', 'limit the number of results [< 100]'
  .option '--location [location]', 'a location for a user'
  .option '--language [language]', 'a language used by a user or in a repo'
  .option '--followers [followers]', 'amount of followers for a repo or user'
  .option '-f, --forks [forks]', 'amount of forks for repo'
  .option '-s, --stars [stars]', 'amount of stars for a repo'


program.on '--help', ->
  console.log '  Examples:'
  console.log '    $ ' + pkg.name + ' --username jh3y'
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
    console.log 'lets go INTERACTIVE up in here'
    criteria = interactiveUtils.getCriteria()
    # startCorvid criteria
  else
    startCorvid program
