
/*
 *
 * Data Utilities for grabbing data simply or paged
 *
 */

(function() {
  var colors, errCallback, getErrCallback, getRequestCallback, getRequestOptions, getResults, getUrlParameters, grab, grabPaged, processSearch, promise, request, requestCallback, requestOptions, resPageLimit;

  colors = require('colors');

  request = require('request');

  promise = require('promise');


  /*
   * GRAB - Our basic HTTP request method for data. Essentially, a request wrapped # in a promise
   */

  exports.grab = grab = function(options) {
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

  exports.grabPaged = grabPaged = function(options, pages) {
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
   * Variables for data requests
   */

  resPageLimit = 100;

  requestOptions = {
    headers: {
      'User-Agent': 'request'
    }
  };

  requestCallback = undefined;

  errCallback = function(err) {
    return console.error(err);
  };

  getUrlParameters = function(criteria, qString, order, sort) {
    var genQueryString, parameterString;
    genQueryString = function() {
      var result;
      result = 'q=';
      if (criteria.username && typeof criteria.username === 'string') {
        result += 'user:' + criteria.username;
      }
      if (criteria.repos) {
        if (typeof criteria.repos === 'string') {
          result += '+repo:' + criteria.repos;
        } else if (typeof criteria.repos !== 'boolean' && typeof (parseInt(criteria.repos, 10)) === 'number') {
          result += '+repos:' + criteria.repos;
        }
      }
      if (criteria.location && typeof criteria.location === 'string') {
        result += '+location:' + criteria.location;
      }
      if (criteria.language && typeof criteria.language === 'string') {
        result += '+language:' + criteria.language;
      }
      if (criteria.followers && typeof criteria.followers !== 'boolean' && typeof parseInt(criteria.followers, 10) === 'number') {
        result += '+followers:%3E' + criteria.followers;
      }
      if (criteria.forks && typeof criteria.repos !== 'boolean' && typeof parseInt(criteria.forks, 10) === 'number') {
        result += '+forks:%3E' + criteria.forks;
      }
      if (criteria.stars && typeof criteria.stars !== 'boolean' && typeof parseInt(criteria.stars, 10) === 'number') {
        result += '+stars:%3E' + criteria.stars;
      }
      return result;
    };
    parameterString = '';
    if (qString) {
      parameterString += genQueryString();
    }
    if (sort && criteria.sort && typeof criteria.sort === 'string') {
      parameterString += '&sort=' + criteria.sort;
    }
    if (order && criteria.order && typeof criteria.order === 'string') {
      parameterString += '&order=' + criteria.order;
    }
    if (criteria.limit && typeof criteria.limit !== 'boolean' && typeof parseInt(criteria.limit, 10) === 'number') {
      parameterString += '&per_page=' + criteria.limit;
    } else {
      criteria.limit = resPageLimit;
      parameterString += '&per_page=' + resPageLimit;
    }
    return parameterString;
  };

  getRequestOptions = function(criteria) {
    var urlBase, urlParameters;
    urlBase = 'https://api.github.com/search/';
    urlParameters = getUrlParameters(criteria, true, true, true);
    requestOptions = {
      headers: {
        'User-Agent': 'request'
      }
    };
    if (criteria.all && criteria.username && typeof criteria.username === 'string' && criteria.repos) {
      requestOptions.url = urlBase + 'repositories?q=user:' + criteria.username + getUrlParameters(criteria, false, false, false);
    } else if (criteria.repos) {
      requestOptions.url = urlBase + 'repositories?' + urlParameters;
    } else {
      requestOptions.url = urlBase + 'users?' + urlParameters;
    }
    return requestOptions;
  };

  getRequestCallback = function(criteria) {
    requestCallback = undefined;
    if (criteria.all && criteria.username && typeof criteria.username === 'string' && criteria.repos) {
      requestCallback = function(data) {
        var pages, response;
        response = JSON.parse(data);
        pages = Math.ceil(response.total_count / criteria.limit);
        console.log(pages, 'is the amount of pages for return');
        return grabPaged(requestOptions, pages).then(function(data) {
          return resolve(data);
        });
      };
    } else {
      requestCallback = function(data) {
        console.log(data);
        return resolve(JSON.parse(data));
      };
    }
    return requestCallback;
  };

  getErrCallback = function() {
    errCallback = function(err) {
      return console.error(err);
    };
    return errCallback;
  };

  processSearch = function(criteria) {
    var prom;
    prom = new promise(function(resolve, reject) {
      requestOptions = getRequestOptions(criteria);
      requestCallback = getRequestCallback(criteria);
      errCallback = getErrCallback();
      console.log(requestOptions.url, 'is where we are going');
      return grab(requestOptions).then(requestCallback, errCallback);
    });
    return prom;
  };


  /*
   *
   * getResults - The entry point to the data module
   *
   */

  exports.getResults = getResults = function(criteria) {
    console.log('grabbing data with ', criteria);
    return new promise(function(resolve, reject) {
      requestOptions = getRequestOptions(criteria);
      requestCallback = undefined;
      if (criteria.all && criteria.username && typeof criteria.username === 'string' && criteria.repos) {
        console.log('THIS IS CALLBACK');
        requestCallback = function(data) {
          var pages, response;
          response = JSON.parse(data);
          pages = Math.ceil(response.total_count / criteria.limit);
          console.log(pages, 'is the amount of pages for return');
          return grabPaged(requestOptions, pages).then(function(data) {
            return resolve(data);
          });
        };
      } else {
        requestCallback = function(data) {
          return resolve(JSON.parse(data));
        };
      }
      errCallback = getErrCallback();
      console.log(requestOptions.url, 'is where we are going');
      return grab(requestOptions).then(requestCallback, errCallback);
    });
  };

}).call(this);
