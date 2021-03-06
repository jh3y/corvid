shell = require 'shelljs'
inquirer = require 'inquirer'
###
#
#  Clone Utilities
#
###

###
  @method process - processes repo data and provides interactive cloning
  @params repos - repos to be listed for interactive clone
###
exports.process = process = (repos) ->
  if not shell.which 'git'
    throw new Error 'Git is required in order to clone repos'
  choices = []
  for repo in repos
    choices.push
      name: repo.name + ': ' + repo.description
      value: repo.clone_url
  inquirer.prompt [
    type: "checkbox"
    message: "Select repos to clone"
    name: "repos"
    choices: choices
  ,
    type: "confirm",
    name: "confirmClone",
    message: "are you sure you want to clone your chosen repos in the current directory (press ENTER for yes)?",
    default: true
  ], (answers) ->
    if answers.repos and answers.repos.length > 0 and answers.confirmClone
      for answer in answers.repos
        shell.exec('git clone ' + answer, silent: true, (code, output) ->
          console.log output.cyan
        )
      console.log '========================================'.cyan
      console.log 'Chosen repos being cloned'.cyan
      console.log '========================================'.cyan
    else
      console.log '========================================'.cyan
      console.log 'No repos were selected for cloning'.cyan
      console.log '========================================'.cyan
  return
