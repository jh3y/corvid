
/*
 *
 * Users
 *
 */

(function() {
  var dataUtils, errCallback, grab, promise, requestCallback, requestOptions, resPageLimit;

  promise = require('promise');

  dataUtils = require('./data');

  resPageLimit = 5;

  requestOptions = {
    headers: {
      'User-Agent': 'request'
    }
  };

  requestCallback = undefined;

  errCallback = function(err) {
    return console.log(err);
  };

  exports.grab = grab = function(gName) {
    return new promise(function(resolve, reject) {
      requestOptions.url = 'https://api.github.com/search/users?q=' + gName + '&per_page=' + resPageLimit;
      requestCallback = function(data) {
        return resolve(JSON.parse(data));
      };
      return dataUtil.grab(requestOptions).then(requestCallback, errCallback);
    });
  };

}).call(this);
