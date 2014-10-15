
/*
 * GETREPODATA - Returns function data as array of objects
 */

(function() {
  var colors, dataUtil, errCallback, grab, promise, request, requestCallback, requestOptions, resPageLimit;

  colors = require('colors');

  request = require('request');

  promise = require('promise');

  dataUtil = require('./data');

  resPageLimit = 100;

  requestOptions = {
    headers: {
      'User-Agent': 'request'
    }
  };

  requestCallback = undefined;

  errCallback = function(err) {
    return console.log(err);
  };

  exports.grab = grab = function(gName, grabAll) {
    return new promise(function(resolve, reject) {
      if (grabAll) {
        requestOptions.url = 'https://api.github.com/search/repositories?q=user:' + gName;
        requestCallback = function(data) {
          var pages, response;
          response = JSON.parse(data);
          pages = Math.ceil(response.total_count / resPageLimit);
          requestOptions.url = requestOptions.url + '&per_page=' + resPageLimit;
          return dataUtil.grabPaged(requestOptions, pages).then(function(data) {
            return resolve(data);
          });
        };
      } else {
        requestOptions.url = 'https://api.github.com/search/repositories?q=user:' + gName + '&per_page=' + resPageLimit;
        requestCallback = function(data) {
          return resolve(JSON.parse(data));
        };
      }
      return dataUtil.grab(requestOptions).then(requestCallback, errCallback);
    });
  };

}).call(this);
