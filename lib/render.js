
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
    if (userData.items && userData.items.length > 0) {
      return console.log('We have USERS');
    } else if (userData.login) {
      return console.log('We have a USER');
    } else {
      throw new Error('Incomplete DATA');
    }
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
