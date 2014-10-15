(function() {
  var colors, errCallback, grab, grabPaged, grabRepoData, pkg, process, promise, request, requestCallback, requestOptions, resPageLimit;

  colors = require('colors');

  request = require('request');

  promise = require('promise');

  pkg = require('../package.json');

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


  /*
   * GRAB - Our basic HTTP request method for data. Essentially, a request wrapped # in a promise
   */

  grab = function(options) {
    return new promise(function(resolve, reject) {
      return request(options, function(e, r, b) {
        var body;
        if (e) {
          return reject(e);
        } else if (r.statusCode !== 200) {
          body = JSON.parse(b);
          return reject(new Error("Unexpected status code: " + r.statusCode + ', ' + body.message));
        }
        return resolve(b);
      });
    });
  };


  /*
   * GRABPAGED - An function that will group grab promises into one promise for
   * grabbing paged data from the API
   */

  grabPaged = function(options, pages) {
    var i, pagedData, promises;
    pagedData = [];
    promises = [];
    i = 1;
    while (i < (pages + 1)) {
      options.url = options.url + '&page=' + i.toString();
      promises.push(grab(options));
      i++;
    }
    return new promise(function(resolve, reject) {
      return promise.all(promises).then(function(data) {
        var len;
        len = 0;
        while (len < data.length) {
          if (pagedData) {
            pagedData = pagedData.concat(JSON.parse(data[len]).items);
          } else {
            pagedData = JSON.parse(data[len]).items;
          }
          len++;
        }
        return resolve(pagedData);
      });
    });
  };


  /*
   * GETREPODATA - Returns function data as array of objects
   */

  grabRepoData = function(gName, grabAll) {
    return new promise(function(resolve, reject) {
      if (grabAll) {
        requestOptions.url = 'https://api.github.com/search/repositories?q=user:' + gName;
        requestCallback = function(data) {
          var pages, response;
          response = JSON.parse(data);
          pages = Math.ceil(response.total_count / resPageLimit);
          requestOptions.url = requestOptions.url + '&per_page=' + resPageLimit;
          return grabPaged(requestOptions, pages).then(function(data) {
            return resolve(data);
          });
        };
      } else {
        requestOptions.url = 'https://api.github.com/search/repositories?q=user:' + gName + '&per_page=' + resPageLimit;
        requestCallback = function(data) {
          return resolve(JSON.parse(data));
        };
      }
      return grab(requestOptions).then(requestCallback, errCallback);
    });
  };


  /*
   * PROCESS - Our entry point function that processes user options.
   */

  exports.process = process = function(options) {
    var gName;
    if (options && ((options.username && typeof options.username === 'string') || (options.organisation && typeof options.organisation === 'string'))) {
      gName = (options.organisation ? options.organisation : options.username);
      return grabRepoData(gName, options.all).then(function(data) {
        return console.log(data);
      });
    } else {
      throw new Error('no username or organisation specified!');
    }
  };

}).call(this);
