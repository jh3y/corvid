(function() {
  var colors, dataUtil, pkg, process, promise, repos, request, resPageLimit;

  colors = require('colors');

  request = require('request');

  promise = require('promise');

  pkg = require('../package.json');

  dataUtil = require('./data');

  repos = require('./repos');

  resPageLimit = 100;


  /*
   * PROCESS - Our entry point function that processes user options.
   */

  exports.process = process = function(options) {
    var gName;
    if (options && ((options.username && typeof options.username === 'string') || (options.organisation && typeof options.organisation === 'string'))) {
      gName = (options.organisation ? options.organisation : options.username);
      if (options.repositories || options.clone) {

        /*
         * REPOS FLAG SET SO GRAB REPOS FOR GIVEN USERNAME/ORG
         */
        return console.log('We are cloning or browsing repos');
      } else {

        /*
         * NO REPO FLAG SO GRAB USER/ORGANISATION - FINDING JUST DETAILS FOR USER OR ORGANISATION
         */
        return console.log('Just grab the user');
      }
    } else {
      throw new Error('no username or organisation specified!');
    }
  };

}).call(this);
