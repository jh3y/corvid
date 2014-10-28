###
#
# Rendering Utilities
#
###

renderRepos = (repoData) ->
  console.log 'We have REPOS'

renderUsers = (userData) ->
  console.log 'We have USERS'

###
# Entry point for rendering request data
###
exports.renderData = renderData = (data) ->
  if data.renderAsRepos
    renderRepos data.data
  else
    renderUsers data.data
