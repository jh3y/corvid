shell = require 'shelljs'
inquirer = require 'inquirer'

exports.process = process = (repos) ->
  if not shell.which 'git'
    throw new Error 'Git is required in order to clone repos'
  console.log 'Git is installed'
  console.log 'Lets clone repos!'
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
  ], (answers) ->
    if answers.repos and answers.repos.length > 0
      for answer in answers.repos
        shell.exec('git clone ' + answer, silent: true, (code, output) ->
          console.log output.cyan
        )
      console.log '========================================'.cyan
      console.log 'All chosen repos cloned'.cyan
      console.log '========================================'.cyan
    else
      console.log '========================================'.cyan
      console.log 'No repos were selected for cloning'.cyan
      console.log '========================================'.cyan
  return
