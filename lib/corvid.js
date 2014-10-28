(function() {
  var colors, dataUtil, pkg, process, processSearchCriteria, promise, renderUtil, request, resPageLimit, searchCriteria;

  colors = require('colors');

  request = require('request');

  promise = require('promise');

  pkg = require('../package.json');

  dataUtil = require('./data');

  renderUtil = require('./render');

  resPageLimit = 100;

  searchCriteria = {
    all: undefined,
    sort: undefined,
    order: undefined,
    limit: undefined,
    type: undefined,
    username: undefined,
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
    var key;
    for (key in searchCriteria) {
      if (searchCriteria.hasOwnProperty(key) && opts.hasOwnProperty(key)) {
        searchCriteria[key] = opts[key];
      }
    }
    return searchCriteria;
  };


  /*
   * PROCESS - Our entry point function that processes user options.
   */

  exports.process = process = function(options) {
    searchCriteria = processSearchCriteria(options);
    if (searchCriteria.repos || searchCriteria.clone || searchCriteria.username || searchCriteria.organisation) {
      return dataUtil.getResults(searchCriteria).then(function(data) {
        return renderUtil.renderData(data);
      });
    } else {
      throw new Error('no username, organisation or repository criteria specified!');
    }
  };

}).call(this);
