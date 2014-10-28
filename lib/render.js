
/*
 *
 * Rendering Utilities
 *
 */

(function() {
  var renderData, renderRepos, renderUsers;

  renderRepos = function(repoData) {
    if (repoData.items && repoData.items.length > 0) {
      return console.log('We have REPOS');
    } else if (repoData.items && repoData.items.length === 0) {
      return console.log('No REPOS match');
    } else {
      throw new Error('Incomplete DATA');
    }
  };

  renderUsers = function(userData) {
    var user, _i, _len, _ref, _results;
    if (userData.items && userData.items.length > 0) {
      console.log('========================================'.cyan);
      console.log('Returning users that match your criteria'.white);
      console.log('========================================'.cyan);
      console.log('');
      console.log('');
      _ref = userData.items;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        user = _ref[_i];
        console.log(' ');
        console.log(user.login.toUpperCase().red);
        console.log('========================'.red);
        console.log('Type'.white, user.type.cyan);
        console.log('Github Url'.white, user.html_url.cyan);
        _results.push(console.log(' '));
      }
      return _results;
    } else if (userData.items && userData.items.length === 0) {
      return console.log('No users match');
    } else if (userData.login) {
      console.log(' ');
      console.log(userData.name.toUpperCase().red, '(', userData.login.red, ')');
      console.log('========================='.red);
      console.log('Handle: '.white, userData.login.cyan);
      console.log('Type: '.white, userData.type.cyan);
      if (userData.bio !== null) {
        console.log('Bio: '.white, userData.bio.toString().cyan);
      }
      if (userData.company !== null && userData.company.trim() !== '') {
        console.log('Company: '.white, userData.company.cyan);
      }
      console.log('Github Url: '.white, userData.html_url.cyan);
      if (userData.blog !== null && userData.blog.trim() !== '') {
        console.log('Site: '.white, userData.blog.cyan);
      }
      if (userData.location !== null && userData.location.trim() !== '') {
        console.log('Location: '.white, userData.location.cyan);
      }
      if (userData.email !== null && userData.email.trim() !== '') {
        console.log('Email: '.white, userData.email.cyan);
      }
      console.log('Available for hire: ', userData.hireable.toString().cyan);
      console.log('Followers: '.white, userData.followers.toString().cyan);
      console.log('Following: '.white, userData.following.toString().cyan);
      console.log('Public repos: '.white, userData.public_repos.toString().cyan);
      console.log('Public gists: '.white, userData.public_gists.toString().cyan);
      return console.log(' ');
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
