(function() {
  var colors, dataUtil, pkg, process, processSearchCriteria, promise, repos, request, resPageLimit, searchCriteria;

  colors = require('colors');

  request = require('request');

  promise = require('promise');

  pkg = require('../package.json');

  dataUtil = require('./data');

  repos = require('./repos');

  resPageLimit = 100;

  searchCriteria = {
    sort: undefined,
    order: undefined,
    limit: undefined,
    repos: undefined,
    location: undefined,
    language: undefined,
    followers: undefined,
    created: undefined,
    size: undefined,
    forks: undefined,
    created: undefined,
    pushed: undefined,
    stars: undefined
  };

  processSearchCriteria = function(opts) {
    var key, _results;
    _results = [];
    for (key in searchCriteria) {
      if (searchCriteria.hasOwnProperty(key && opts[key])) {
        _results.push(searchCriteria[key] = opts[key]);
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };


  /*
   * PROCESS - Our entry point function that processes user options.
   */

  exports.process = process = function(options) {

    /*
      corvid -r [repoName] user/size/forks/created/stars/pushed
     */
    var gName;
    if (options && ((options.repos && typeof options.repos === 'string') || (options.clone && typeof options.clone === 'string'))) {
      if (options.clone) {
        return console.log('Cloning repos of certain name');
      } else {
        return console.log('Browsing repos');
      }
    } else if (options && ((options.username && typeof options.username === 'string') || (options.organisation && typeof options.organisation === 'string'))) {
      gName = (options.organisation ? options.organisation : options.username);
      if (options.repos || options.clone) {

        /*
         * REPOS FLAG SET SO GRAB REPOS FOR GIVEN USERNAME/ORG
         */
        return console.log('We are cloning or browsing repos for a user');
      } else {

        /*
         * NO REPO FLAG SO GRAB USER/ORGANISATION - FINDING JUST DETAILS FOR USER OR ORGANISATION
         */
        return console.log('Just grab the user');
      }
    } else {
      throw new Error('no username, organisation or repository criteria specified!');
    }
  };

}).call(this);
