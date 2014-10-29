inquirer = require 'inquirer'
###
#
# Interactive utilities
#
###

# criteria =
#   all: options.all
#   username: options.username
#   repos: options.repos
#   interactive: options.interactive
#   organisation: options.organisation
#   clone: options.clone
#   bare: options.bare
#   sort: options.sort
#   order: options.order
#   limit: options.limit
#   location: options.location
#   language: options.language
#   followers: options.followers
#   forks: options.forks
#   stars: options.stars

#TODO: turn this into a promise so that we return criteria then do our start

userQuestions = [
  type: 'input'
  name: 'userName'
  message: 'Enter the name of the user you are looking for (leave blank if not known)'
,
  type: 'input'
  name: 'location'
  message: 'Enter a location for user/s (leave blank if not required)'
,
  type: 'input'
  name: 'language'
  message: 'Enter a language that the user is using (leave blank if not required)'
,
  type: 'input'
  name: 'followers'
  message: 'Enter the minimum number of followers for user/s (leave blank if not required)'
,
  type: 'confirm'
  name: 'bare'
  message: 'Would you like returned information to omit extra details such as followers etc.?'
,
  type: 'input'
  name: 'limit'
  message: 'Enter the limit on the amount of returned results (leave blank if fine with 100 MAX)'
]


repoQuestions = [
  type: 'input'
  name: 'repoName'
  message: 'Enter the name for a repo or repos if searching by name (else leave blank)'
,
  type: 'input'
  name: 'userName'
  message: 'Enter the user associated with the repo/s if there is one (else leave blank)'
,
  type: 'input'
  name: 'language'
  message: 'Enter the language for the repo/s (leave blank if non specific)'
,
  type: 'input'
  name: 'stars'
  message: 'Enter the minimum number of stars for repo/s (leave blank for no minimum)'
,
  type: 'input'
  name: 'forks'
  message: 'Enter the minimum number of forks for repo/s (leave blank for no minimum)'
,
  type: 'confirm'
  name: 'grabAll'
  message: 'Would you like to grab all of the repos matching your criteria? (if expecting more than 100 results)'
,
  type: 'confirm'
  name: 'clone'
  message: 'Would you like to clone any of the found repos? (can do more than one at once)'
,
  type: 'confirm'
  name: 'bare'
  message: 'Would you like to strip some information from the results?'
,
  type: 'list'
  name: 'order'
  choices: [
    'stars'
  ,
    'forks'
  ,
    'updated'
  ]
  default: 0
  message: 'Choose which stat you would like to order results by'
,
  type: 'list'
  name: 'sort'
  choices: [
    'Descending'
  ,
    'Ascending'
  ]
  default: 0
  message: 'Choose the sort order'
,
  type: 'input'
  name: 'limit'
  message: 'Enter the limit on the amount of returned results (leave blank if fine with 100 MAX or requesting all results)'
]




exports.getCriteria = getCriteria = ->
  inquirer.prompt [
    type: 'confirm'
    name: 'searchForRepo'
    message: 'Are you searching for a repo or repos?'
  ], (answers) ->
    if answers.searchForRepo
      console.log 'show repo questions'
      inquirer.prompt repoQuestions, (answers) ->
        console.log JSON.stringify answers
    else
      console.log 'show user questions'
      inquirer.prompt userQuestions, (answers) ->
        console.log JSON.stringify answers
  return
