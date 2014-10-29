###
#
# Rendering Utilities
#
###
renderRepo = (repo) ->
  console.log ''
  console.log '========================='.red
  console.log repo.name.toUpperCase().red
  if repo.description isnt null and repo.description.trim() isnt ''
    console.log repo.description.red
  console.log '========================='.red
  if repo.homepage isnt null and repo.homepage.trim() isnt ''
    console.log 'Homepage: '.white, repo.homepage.cyan
  console.log 'Owner: '.white, repo.owner.login.cyan
  if repo.language isnt null and repo.language.trim() isnt ''
    console.log 'Language: '.white, repo.language.cyan
  console.log 'Github Url: '.white, repo.html_url.cyan
  console.log 'Clone Url: '.white, repo.clone_url.cyan
  console.log 'Stars: '.white, repo.stargazers_count.toString().cyan
  console.log 'Forks: '.white, repo.forks.toString().cyan
  console.log 'Watchers: '.white, repo.watchers_count.toString().cyan
  console.log '# of open issues: '.white, repo.open_issues.toString().cyan
  console.log 'Last updated: '.white, new Date(repo.updated_at).toString().cyan
  console.log ''

renderRepos = (repoData) ->
  if repoData.items and repoData.items.length > 0
    console.log '========================================'.cyan
    console.log 'Returning repos that match your criteria'.white
    console.log '========================================'.cyan
    for repo in repoData.items
      renderRepo repo
  else if repoData.items and repoData.items.length is 0
    console.log '========================================'.cyan
    console.log 'No matching repos for your criteria'.white
    console.log '========================================'.cyan
  else
    throw new Error 'Incomplete DATA'

renderUser = (user) ->
  console.log ' '
  console.log '========================='.red
  console.log user.name.toUpperCase().red, '(', user.login.red, ')'
  if user.bio isnt null
    console.log user.bio.toString().red
  console.log '========================='.red
  console.log 'Handle: '.white, user.login.cyan
  console.log 'Type: '.white, user.type.cyan
  console.log 'Joined: '.white, new Date(user.created_at).toString().cyan
  if user.company isnt null and user.company.trim() isnt ''
    console.log 'Company: '.white, user.company.cyan
  console.log 'Github Url: '.white, user.html_url.cyan
  if user.blog isnt null and user.blog.trim() isnt ''
    console.log 'Site: '.white, user.blog.cyan
  if user.location isnt null and user.location.trim() isnt ''
    console.log 'Location: '.white, user.location.cyan
  if user.email isnt null and user.email.trim() isnt ''
    console.log 'Email: '.white, user.email.cyan
  console.log 'Available for hire: ', user.hireable.toString().cyan
  console.log 'Followers: '.white, user.followers.toString().cyan
  console.log 'Following: '.white, user.following.toString().cyan
  console.log 'Public repos: '.white, user.public_repos.toString().cyan
  console.log 'Public gists: '.white, user.public_gists.toString().cyan
  console.log ' '


renderUsers = (userData) ->
  if userData.items and userData.items.length > 0
    console.log '========================================'.cyan
    console.log 'Returning users that match your criteria'.white
    console.log '========================================'.cyan
    console.log ''
    console.log ''
    for user in userData.items
      console.log ' '
      console.log '========================'.red
      console.log user.login.toUpperCase().red
      console.log '========================'.red
      console.log 'Type: '.white, user.type.cyan
      console.log 'Github Url: '.white, user.html_url.cyan
      console.log ' '
  else if userData.items and userData.items.length is 0
    console.log '========================================'.cyan
    console.log 'No matching users for your criteria'.white
    console.log '========================================'.cyan
  else if userData.login
    renderUser userData
  else
    throw new Error 'Incomplete DATA'

###
# Entry point for rendering request data
###
exports.renderData = renderData = (data, criteria) ->
  if data.renderAsRepos
    renderRepos data.data
  else
    renderUsers data.data
