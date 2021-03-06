(function() {
  var colors, dataUtil, pkg, process, processSearchCriteria, promise, renderUtil, request, resPageLimit, searchCriteria;

  colors = require('colors');

  request = require('request');

  promise = require('promise');

  pkg = require('../package.json');

  dataUtil = require('./data');

  renderUtil = require('./render');

  resPageLimit = 100;


  /*
   *
   * Corvid
   *
   */

  searchCriteria = {
    all: undefined,
    bare: undefined,
    clone: undefined,
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


  /*
    @method processSearchCriteria - process options and generate user criteria
    @params opts - user defined options
   */

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
    @method process - process user options, get data and render it
    @params options - user options
   */

  exports.process = process = function(options) {
    searchCriteria = processSearchCriteria(options);
    if (searchCriteria.repos || searchCriteria.username) {
      return dataUtil.getResults(searchCriteria).then(function(data) {
        return renderUtil.renderData(data, searchCriteria);
      });
    } else {
      throw new Error('no username, organisation or repository criteria specified!');
    }
  };

}).call(this);
