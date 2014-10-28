###
#
# Rendering Utilities
#
###

renderRepos = (repoData) ->
  if repoData.items and repoData.items.length > 0
    console.log 'We have REPOS'
  else if repoData.items and repoData.items.length is 0
    console.log 'No REPOS match'
  else
    throw new Error 'Incomplete DATA'


renderUsers = (userData) ->
  if userData.items and userData.items.length > 0
    console.log 'We have USERS'
    for user in userData.items
      console.log '#####'.green
      console.log user.login.red
      console.log 'Type'.white, user.type.cyan
      console.log 'URL'.white, user.html_url.cyan
      console.log '#####'.green
  else if userData.items and userData.items.length is 0
    console.log 'No users match'
  else if userData.login
    console.log 'We have a USER', userData
    console.log ' '
    console.log userData.name.toUpperCase().red, '(', userData.login.red, ')'
    console.log '========================='.red
    console.log 'Handle: '.white, userData.login.cyan
    console.log 'Type: '.white, userData.type.cyan
    if userData.bio isnt null
      console.log 'Bio: '.white, userData.bio.toString().cyan
    if userData.company isnt null and userData.company.trim() isnt ''
      console.log 'Company: '.white, userData.company.cyan
    console.log 'Github Url: '.white, userData.html_url.cyan
    if userData.blog isnt null and userData.blog.trim() isnt ''
      console.log 'Site: '.white, userData.blog.cyan
    if userData.location isnt null and userData.location.trim() isnt ''
      console.log 'Location: '.white, userData.location.cyan
    if userData.email isnt null and userData.email.trim() isnt ''
      console.log 'Email: '.white, userData.email.cyan
    console.log 'Available for hire: ', userData.hireable.toString().cyan
    console.log 'Followers: '.white, userData.followers.toString().cyan
    console.log 'Following: '.white, userData.following.toString().cyan
    console.log 'Public repos: '.white, userData.public_repos.toString().cyan
    console.log 'Public gists: '.white, userData.public_gists.toString().cyan
    console.log ' '
  else
    throw new Error 'Incomplete DATA'

###
# Entry point for rendering request data
###
exports.renderData = renderData = (data) ->
  if data.renderAsRepos
    renderRepos data.data
  else
    renderUsers data.data
