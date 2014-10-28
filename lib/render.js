
/*
 *
 * Rendering Utilities
 *
 */

(function() {
  var renderData, renderRepos, renderUsers;

  renderRepos = function(repoData) {
    return console.log('We have REPOS');
  };

  renderUsers = function(userData) {
    return console.log('We have USERS');
  };


  /*
   * Entry point for rendering request data
   */

  exports.renderData = renderData = function(data) {
    if (data.renderAsRepos) {
      return renderRepos(data.data);
    } else {
      return renderUsers(data.data);
    }
  };

}).call(this);
