program = require "commander"
colors = require "colors"
pkg = require "../package.json"
corvid = require "./corvid"

program
  .version(pkg.version)
  .option "-u, --username [username]", "git username to be browsed"
  .option "-o, --organisation [organisation]", "git organisation to be browsed"
  .option "-c, --clone", "provide interactive cloning"
  .option "-d, --detailed", "return repo details"

program.on "--help", ->
  console.log "  Examples:"
  console.log ""
  console.log "    $ " + pkg.name + " --browse jh3y"
  return

program.parse process.argv

if process.argv.length is 2
  program.help()
else
  try
    corvid.process
      username: program.username
      organisation: program.organisation
      clone: program.clone
      detailed: program.detailed
  catch err
    console.log "[", "corvid".white, "]", err.toString().red
