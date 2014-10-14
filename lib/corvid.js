(function() {
  var colors, grab, grabPaged, pkg, process, promise, request, resPageLimit;

  colors = require('colors');

  request = require('request');

  promise = require('promise');

  pkg = require('../package.json');

  resPageLimit = 50;

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

  grabPaged = function(options, pages) {
    var i, promises, repoData;
    repoData = [];
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
        repoData = undefined;
        len = 0;
        while (len < data.length) {
          if (repoData) {
            repoData = repoData.concat(data[len]);
          } else {
            repoData = data[len];
          }
          len++;
        }
        return resolve(repoData);
      });
    });
  };

  exports.process = process = function(options) {
    var requestOptions;
    if (options && options.username && typeof options.username === 'string') {
      requestOptions = {
        url: 'https://api.github.com/users/' + options.username.toString(),
        headers: {
          'User-Agent': 'request'
        }
      };
      return grab(requestOptions).then(function(data) {
        var pages, response;
        response = JSON.parse(data);
        pages = Math.ceil(response.public_repos / resPageLimit);
        requestOptions.url = requestOptions.url + '/repos?per_page=' + resPageLimit;
        return grabPaged(requestOptions, pages).then(function(data) {
          return console.log('DATA PULLED WHOOOP');
        });
      }, function(err) {
        return console.log(err);
      });
    } else if (options && options.organisation && typeof options.organisation === 'string') {
      return console.log('lets grab an organisation then');
    } else {
      throw new Error('no username or organisation specified!');
    }
  };

}).call(this);
