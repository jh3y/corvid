
/*
 *
 * Rendering Utilities
 *
 */

(function() {
  var renderData, renderRepo, renderRepos, renderUser, renderUsers;

  renderRepo = function(repo) {
    console.log('');
    console.log('========================='.red);
    console.log(repo.name.toUpperCase().red);
    if (repo.description !== null && repo.description.trim() !== '') {
      console.log(repo.description.red);
    }
    console.log('========================='.red);
    if (repo.homepage !== null && repo.homepage.trim() !== '') {
      console.log('Homepage: '.white, repo.homepage.cyan);
    }
    console.log('Owner: '.white, repo.owner.login.cyan);
    if (repo.language !== null && repo.language.trim() !== '') {
      console.log('Language: '.white, repo.language.cyan);
    }
    console.log('Github Url: '.white, repo.html_url.cyan);
    console.log('Clone Url: '.white, repo.clone_url.cyan);
    console.log('Stars: '.white, repo.stargazers_count.toString().cyan);
    console.log('Forks: '.white, repo.forks.toString().cyan);
    console.log('Watchers: '.white, repo.watchers_count.toString().cyan);
    console.log('# of open issues: '.white, repo.open_issues.toString().cyan);
    console.log('Last updated: '.white, new Date(repo.updated_at).toString().cyan);
    return console.log('');
  };

  renderRepos = function(repoData) {
    var repo, _i, _len, _ref, _results;
    if (repoData.items && repoData.items.length > 0) {
      console.log('========================================'.cyan);
      console.log('Returning repos that match your criteria'.white);
      console.log('========================================'.cyan);
      _ref = repoData.items;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        repo = _ref[_i];
        _results.push(renderRepo(repo));
      }
      return _results;
    } else if (repoData.items && repoData.items.length === 0) {
      console.log('========================================'.cyan);
      console.log('No matching repos for your criteria'.white);
      return console.log('========================================'.cyan);
    } else {
      throw new Error('Incomplete DATA');
    }
  };

  renderUser = function(user) {
    console.log(' ');
    console.log('========================='.red);
    console.log(user.name.toUpperCase().red, '(', user.login.red, ')');
    if (user.bio !== null) {
      console.log(user.bio.toString().red);
    }
    console.log('========================='.red);
    console.log('Handle: '.white, user.login.cyan);
    console.log('Type: '.white, user.type.cyan);
    console.log('Joined: '.white, new Date(user.created_at).toString().cyan);
    if (user.company !== null && user.company.trim() !== '') {
      console.log('Company: '.white, user.company.cyan);
    }
    console.log('Github Url: '.white, user.html_url.cyan);
    if (user.blog !== null && user.blog.trim() !== '') {
      console.log('Site: '.white, user.blog.cyan);
    }
    if (user.location !== null && user.location.trim() !== '') {
      console.log('Location: '.white, user.location.cyan);
    }
    if (user.email !== null && user.email.trim() !== '') {
      console.log('Email: '.white, user.email.cyan);
    }
    console.log('Available for hire: ', user.hireable.toString().cyan);
    console.log('Followers: '.white, user.followers.toString().cyan);
    console.log('Following: '.white, user.following.toString().cyan);
    console.log('Public repos: '.white, user.public_repos.toString().cyan);
    console.log('Public gists: '.white, user.public_gists.toString().cyan);
    return console.log(' ');
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
        console.log('========================'.red);
        console.log(user.login.toUpperCase().red);
        console.log('========================'.red);
        console.log('Type: '.white, user.type.cyan);
        console.log('Github Url: '.white, user.html_url.cyan);
        _results.push(console.log(' '));
      }
      return _results;
    } else if (userData.items && userData.items.length === 0) {
      console.log('========================================'.cyan);
      console.log('No matching users for your criteria'.white);
      return console.log('========================================'.cyan);
    } else if (userData.login) {
      return renderUser(userData);
    } else {
      throw new Error('Incomplete DATA');
    }
  };


  /*
   * Entry point for rendering request data
   */

  exports.renderData = renderData = function(data, criteria) {
    if (data.renderAsRepos) {
      return renderRepos(data.data);
    } else {
      return renderUsers(data.data);
    }
  };

}).call(this);
