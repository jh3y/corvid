###
#
# Rendering Utilities
#
###

renderRepos = (repoData) ->
  console.log 'We have REPOS'

renderUsers = (userData) ->
  if userData.items and userData.items.length > 0
    console.log 'We have USERS'
  else if userData.login
    console.log 'We have a USER'
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
